#!/usr/bin/env ruby

require 'faraday'
require 'json'
require 'tmpdir'
require 'fileutils'

INSTANCE_ENDPOINT = ENV['INSTANCE_ENDPOINT']
QUEUE_ENDPOINT = ENV['QUEUE_ENDPOINT']
INSTANCE = ENV['INSTANCE']

job_count = 0

def faraday
  @faraday ||= Faraday.new(url: QUEUE_ENDPOINT) do |f|
    puts "Setup Faraday with endpoint #{QUEUE_ENDPOINT}"
    uri = URI.parse(QUEUE_ENDPOINT)
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
end

def queue_url(job)
  [QUEUE_ENDPOINT, job['id']] * '/'
end

def claim(job)
  puts "Claiming job #{job}..."
  response = faraday.put(queue_url(job), job: {event: 'start', locked_by: INSTANCE})
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
def prepare_wave(path)
  wav = nil
  Dir.chdir(path) do
    mp3 = Dir.glob('*.mp3').first
    wav = mp3.sub('.mp3', '.wav')
    system "sox #{mp3} #{wav}"
  end
  wav
end

def complete(job)
  puts "Marking job #{job} as complete."
  faraday.put(queue_url(job), event: 'complete')
end

def run(job)
  puts "Running job #{job}..."

  source = Dir.tmpdir
  local  = Dir.tmpdir
  target = Dir.tmpdir

  source_bucket = [ job['details']['recording']['bucket'],
                    job['details']['recording']['prefix'] ] * '/'
  target_bucket = [ job['details']['archive']['bucket'],
                    job['details']['archive']['prefix'] ] * '/'

  s3fs_mount(source_bucket, source)
  s3fs_mount(target_bucket, target)

  manifest_path = "#{target}/manifest.yml"

  # copy relevant files from source to local
  manifest = YAML.load(File.read(manifest_path))
  manifest[:relevant_files].each do |file|
    FileUtils.cp(File.join(source, file.first), local)
  end

  # copy relevant files from target to local
  system "cp #{manifest_path} #{local}"

  fidelity(local)
  wave = prepare_wave(local)
  wav2json(path, wave)

  # cleanup
  File.unlink(wave)
  system "rm #{local}/dump_*"

  # copy relevant files from local to target
  system "cp #{local}/* #{target}"

  s3fs_umount(source)
  s3fs_umount(target)

  FileUtils.rm_rf(source)
  FileUtils.rm_rf(local)
  FileUtils.rm_rf(target)

  complete(job)
end

def wait
  puts "Sleeping for 1 min."
  sleep 60
end

def instance_url
  [INSTANCE_ENDPOINT, INSTANCE] * '/'
end

def public_ip_address
  faraday.get('http://169.254.169.254/latest/meta-data/public-ipv4').body
end

def report_ready
  faraday.put(instance_url, instance:
                              { public_ip_address: public_ip_address,
                                event: 'complete'})
end

def report_terminate
  faraday.put(instance_url, instance: { event: 'terminate' })
end

# args = Hash[ ARGV.join(' ').scan(/--?([^=\s]+)(?:=(\S+))?/) ]

report_ready
while true
  jobs = job_list
  if jobs.empty?
    puts "Job list empty."
    if job_count > 0
      report_terminate
      terminate
    else
      wait
    end
  else
    job = jobs.first
    run(job) if claim(job)
  end
end
