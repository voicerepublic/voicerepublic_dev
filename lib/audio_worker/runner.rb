#!/usr/bin/env ruby

require 'faraday'
require 'json'
require 'tmpdir'
require 'fileutils'
require 'yaml'

# make it autoflush
STDOUT.sync = true

INSTANCE_ENDPOINT = ENV['INSTANCE_ENDPOINT']
QUEUE_ENDPOINT = ENV['QUEUE_ENDPOINT']
INSTANCE = ENV['INSTANCE']

# terminate if there is nothing to do for 6 hours
MAX_WAIT_COUNT = 60 * 6

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
  while response.status != 200 do
    puts "Response Status #{response.status}, endpoint unavailable?"
    puts "Waiting for 10 seconds then retry..."
    sleep 10
    puts "Retrying..."
    response = faraday.get
  end
  JSON.parse(response.body)
end

def terminate
  faraday.put(instance_url, instance: { event: 'terminate' })
  puts "Terminate!"
  exit 0
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
  puts %x[./fidelity/bin/fidelity run #{path}/manifest.yml]
end

def wav2json(path, file)
  puts "Running wav2json..."
  puts %x[./wav2json.sh #{path}/#{file}]
end

# find the first mp3 in path, convert it to wav and return its name
def prepare_wave(path)
  puts "Preparing wave file..."
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
  faraday.put(queue_url(job), job: {event: 'complete'})

  File.open(File.join(ENV['HOME'], 'job.log'), 'a') do |f|
    f.puts "Marked job #{job['id']} as completed."
  end
end

def s3_cp(source, target, region=nil)
  cmd = "aws s3 cp #{source} #{target}"
  cmd += " --region #{region}" unless region.nil?
  puts cmd
  puts %x[#{cmd}]
end

def s3_sync(source, target, region=nil)
  cmd = "aws s3 sync #{source} #{target}"
  cmd += " --region #{region}" unless region.nil?
  puts cmd
  puts %x[#{cmd}]
end

def probe_duration(path)
  cmd = "ffmpeg -i #{path} 2>&1 | grep Duration"
  output = %x[ #{cmd} ]
  md = output.match(/\d+:\d\d:\d\d/)
  md ? md[0] : nil
end

def metadata(file)
  duration = probe_duration(file)
  result = {
    basename: File.basename(file),
    ext:      File.extname(file),
    size:     File.size(file),
    duration: duration
  }
  # add duration in seconds
  if duration
    h, m, s = duration.split(':').map(&:to_i)
    result[:seconds] = (h * 60 + m) * 60 + s
  end
  result
end

def whatever2ogg(path)
  wav = "#{path}.wav"
  ogg = "#{path}.ogg"

  %x[ ffmpeg -n -loglevel panic -i #{path} #{wav}; \
      oggenc -Q -o #{ogg} #{wav}]

  [wav, ogg]
end

def run(job)
  puts "Running job #{job['id']}..."

  File.open(File.join(ENV['HOME'], 'job.log'), 'a') do |f|
    f.puts "Claimed job #{job['id']}."
  end

  tmp_prefix = "job_#{job['id']}_"

  path = Dir.mktmpdir(tmp_prefix)

  source_bucket = [ 's3:/',
                    job['details']['recording']['bucket'],
                    job['details']['recording']['prefix'] ] * '/'
  target_bucket = [ 's3:/',
                    job['details']['archive']['bucket'],
                    job['details']['archive']['prefix'] ] * '/'

  source_region = job['details']['recording']['region']
  target_region = job['details']['archive']['region']

  type = job['type']

  puts "Working directory: #{path}"
  puts "Source bucket:     #{source_bucket}"
  puts "Target bucket:     #{target_bucket}"
  puts "Job Type:          #{type}"

  case type

  when "Job::Archive"

    # pull manifest file
    manifest_url = "#{target_bucket}/manifest.yml"
    s3_cp(manifest_url, path, target_region)

    # based on content pull source files
    manifest_path = File.join(path, 'manifest.yml')
    raise "No manifest file!" unless File.exist?(manifest_path)
    manifest = YAML.load(File.read(manifest_path))
    manifest[:relevant_files].each do |file|
      s3_url = "#{source_bucket}/#{file.first}"
      s3_cp(s3_url, path, source_region)
    end

  when "Job::ProcessUpload"

    url = job['upload_url']
    filename = url.split('/').last

    if url.match(/^s3:\/\//)
      s3_cp(url, path, source_region)
    else
      %x[ cd #{path}; wget --no-check-certificate -q '#{url}' ]
    end

    upload = File.join(path, filename)

    wav, ogg = whatever2ogg(upload)
    File.unlink(upload)
    File.rename(ogg, "#{path}/override.ogg")

    # TODO the oldschool way of uploading stuff would have set
    # `recording_override` to the s3 url of the ogg file

    manifest_path = File.join(path, 'manifest.yml')
    manifest = YAML.load(File.read(manifest_path))
    name = manifest[:id]

    File.rename(wav, "#{path}/#{name}.wav")

  else

    slack "Unknown job type: #{type}, job: `#{job.inspect}`"
    terminate

  end

  # bulk work
  fidelity(path)
  wave = prepare_wave(path)
  wav2json(path, wave)

  # cleanup: delete dump files
  File.unlink(File.join(path, wave))
  manifest[:relevant_files].each do |file|
    dump = File.join(path, file.first)
    File.unlink(dump)
  end

  # collect index data
  index = {}
  prefix = job['details']['archive']['prefix']
  Dir.glob(File.join(path, '*')).each do |file|
    base = File.basename(file)
    index["#{prefix}/#{base}"] = metadata(file)
  end

  # write index file
  File.open(File.join(path, 'index.yml'), 'w') do |f|
    f.write(YAML.dump(index))
  end

  # upload all files from path to target_bucket
  s3_sync(path, target_bucket+'/', target_region)

  # cleanup: delete everything
  FileUtils.rm_rf(path)

  # mark job as completed
  complete(job)
end

def wait
  puts 'Sleeping for 1 min. Then poll queue again...'
  sleep 60
end

def instance_url
  [INSTANCE_ENDPOINT, INSTANCE] * '/'
end

def public_ip_address
  faraday.get('http://169.254.169.254/latest/meta-data/public-ipv4').body
rescue
  nil
end

def report_ready
  faraday.put(instance_url, instance:
                              { public_ip_address: public_ip_address,
                                event: 'complete'})
end

def report_failure
  faraday.put(instance_url, instance: { event: 'failed' })
end

def slack(message)
  url = "https://voicerepublic.slack.com/services/hooks/incoming-webhook"+
        "?token=VtybT1KujQ6EKstsIEjfZ4AX"
  payload = {
    channel: '#voicerepublic_tech',
    username: 'audio_worker',
    text: message,
    icon_emoji: ':zombie:'
  }
  json = JSON.unparse(payload)
  cmd = "curl -X POST --data-urlencode 'payload=#{json}' '#{url}' 2>&1"
  %x[ #{cmd} ]
end

job_count = 0
wait_count = 0

# this is just a test
slack "`#{INSTANCE}` up and running..."

# with a region given this should always work
%x[aws configure set default.s3.signature_version s3v4]

# main
begin
  report_ready
  while true
    jobs = job_list
    if jobs.empty?
      puts "Job list empty."
      if job_count > 0
        terminate
      end
      if wait_count >= MAX_WAIT_COUNT
        slack "`#{INSTANCE}` terminating after 6 hours idle time."
        terminate
      end
      wait
      wait_count += 1
    else
      job = jobs.first
      if claim(job)
        run(job)
        job_count += 1
        wait_count = 0
      else
        puts "Failed to claim job #{job['id']}"
        sleep 5
      end
    end
  end
rescue => e
  report_failure
  case e.message
  when "no inputs?"
    slack "Something went wrong: `#{e.message}`"
    slack "`#{INSTANCE}` terminated."
    exit 0
  else
    slack "Something went wrong: `#{e.message}`"
    slack "`#{INSTANCE}` on `#{public_ip_address}`" +
          " NOT terminating. Action required!"
    exit 1
  end
end
