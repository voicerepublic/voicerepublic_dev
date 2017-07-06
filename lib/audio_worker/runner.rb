#!/usr/bin/env ruby

require 'faraday'
require 'json'
require 'tmpdir'
require 'fileutils'
require 'yaml'

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
  puts "Claiming job #{job['id']}..."
  response = faraday.put(queue_url(job), job: {event: 'start', locked_by: INSTANCE})
  response.status == 200
end

def fidelity(path)
  puts "Running fidelity..."
  puts %x[docker run --name fidelity -v #{path}:/audio branch14/fidelity]
  puts %x[docker rm fidelity]
end

def wav2json(path, file)
  puts "Running wav2json..."
  puts %x[docker run --name wav2json -v #{path}:/share \
          -e INPUT=#{file} -e PRECISION=6 branch14/wav2json]
  puts %x[docker rm wav2json]
end

# find the first mp3 in path, convert it to wav and return its name
def prepare_wave(path)
  wav = nil
  Dir.chdir(path) do
    mp3 = Dir.glob('*.mp3').first
    raise 'no mp3' if mp3.nil?
    wav = mp3.sub('.mp3', '.wav')
    system "sox #{mp3} #{wav}"
  end
  wav
end

def complete(job)
  puts "Marking job #{job['id']} as complete."
  faraday.put(queue_url(job), event: 'complete')
end

def s3_get(source, target)
  #puts "Downloading #{source} to #{target}"
  puts %x[s4cmd -f get #{source} #{target}]
end

def s3_put(source, target)
  #puts "Uploading #{source} to #{target}"
  puts %x[s4cmd -f put #{source} #{target}]
end


def run(job)
  puts "Running job #{job['id']}..."

  prefix = "job_#{job['id']}_"

  path = Dir.mktmpdir(prefix)

  source_bucket = [ 's3:/',
                    job['details']['recording']['bucket'],
                    job['details']['recording']['prefix'] ] * '/'
  target_bucket = [ 's3:/',
                    job['details']['archive']['bucket'],
                    job['details']['archive']['prefix'] ] * '/'

  puts "Working directory: #{path}"
  puts "Source bucket:     #{source_bucket}"
  puts "Target bucket:     #{target_bucket}"

  # pull manifest file
  manifest_url = "#{target_bucket}/manifest.yml"
  s3_get(manifest_url, path)

  # based on content pull source files
  manifest_path = File.join(path, 'manifest.yml')
  manifest = YAML.load(File.read(manifest_path))
  manifest[:relevant_files].each do |file|
    s3_url = "#{source_bucket}/#{file.first}"
    s3_get(s3_url, path)
  end

  fidelity(path)
  wave = prepare_wave(path)
  wav2json(path, wave)

  # cleanup
  File.unlink(File.join(path, wave))
  manifest[:relevant_files].each do |file|
    dump = File.join(path, file.first)
    File.unlink(dump)
    #%x["rm #{path}/#{file.first}"]
  end

  # upload relevant files from path to target_bucket
  s3_put(File.join(path, '*'), target_bucket+'/')

  FileUtils.rm_rf(path)

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
    if claim(job)
      run(job)
      job_count += 1
    end
  end
end
