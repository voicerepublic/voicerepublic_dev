#!/usr/bin/env ruby

require 'faraday'
require 'json'
require 'tmpdir'
require 'fileutils'

ENDPOINT = ENV['QUEUE']

job_count = 0

def faraday
  @faraday ||= Faraday.new(url: ENDPOINT) do |f|
    puts "Setup Faraday with endpoint #{ENDPOINT}"
    uri = URI.parse(ENDPOINT)
    f.basic_auth(uri.user, uri.password)
    f.request :url_encoded
    f.adapter Faraday.default_adapter
  end
end

def die(response)
  warn "It is dead, Jim."
  exit
end

def job_list
  puts "Retrieving job list..."
  response = faraday.get
  die(response) unless response.status == 200
  JSON.parse(response.body)
end

def terminate
  puts "Terminate!"
  exit
  # https://stackoverflow.com/questions/10541363/self-terminating-aws-ec2-instance
  #%x[sudo shutdown -h now]
end

def url(job)
  [ENDPOINT, job['id']] * '/'
end

def claim(job)
  puts "Claiming job #{job}..."
  response = faraday.post(url(job), worker_id: INSTANCE)
  response.status == 200
end

def s3fs_mount(bucket, path)
  puts "Mounting bucket to #{path}..."
  system "/usr/local/bin/s3fs #{bucket} #{path}"
end

def fidelity(path)
  puts "Running fidelity..."
  system "docker run --name fidelity -v #{path}:/audio branch14/fidelity"
  system "docker rm fidelity"
end

def wav2json(path)
  puts "Running wav2json..."
  system "docker run --name wav2json -v #{path}:/share "+
         "-e INPUT=#{file} -e PRECISION=6 branch14/wav2json"
  system "docker rm wav2json"
end

def s3fs_umount(path)
  puts "Umounting bucket..."
  system "umount #{path}"
end

# find the first mp3 in path, convert it to wav and return its name
def prepare_file(path)
  wav = nil
  Dir.chdir(path) do
    mp3 = Dir.glob('*.mp3').first
    wav = mp3.sub('.mp3', '.wav')
    system "sox #{mp3} #{wav}"
  end
  wav
end

def run(job)
  puts "Running job #{job}..."
  path = Dir.tmpdir
  bucket = job # TODO get bucket from job
  s3fs_mount(bucket, path)
  fidelity(path)
  file = prepare_file(path)
  wav2json(path, file)
  s3fs_umount(path)
  FileUtils.rm_rf(path)
  puts "Job complete, deleting job #{job}..."
  faraday.delete(url(job))
end

def wait
  puts "Sleeping for 1 min."
  sleep 60
end

while true
  jobs = job_list
  if jobs.empty?
    puts "Job list empty."
    if job_count > 0
      terminate
    else
      wait
    end
  else
    job = jobs.first
    run(job) if claim(job)
  end
end
