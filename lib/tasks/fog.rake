require 'inifile'

namespace :fog do

  desc 'list all buckets'
  task list: :environment do

    template = "% -40s % -20s % -20s"

    aws.directories.all.each do |bucket|
      acl = nil # aws.get_bucket_acl(bucket.key).body
      puts template % [bucket.key, bucket.location, acl]
    end
  end


  desc 'create s3 buckets and set permissions'
  task setup: :environment do

    bucket_names = aws.directories.all.map(&:key)

    buckets = [
      # common
      { key: 'vr-ftp-files', location: 'eu-central-1' },
      # dev
      { key: 'vr-audio-uploads-dev', acl: 'public-read-write' },
      { key: 'vr-slide-uploads-dev', acl: 'public-read-write' },
      { key: 'vr-dev-import' },
      { key: 'vr-dev-logs' },
      { key: 'vr-dev-media' },
      { key: 'vr-dev-images', location: 'eu-central-1' },
      # staging
      { key: 'vr-audio-uploads-staging', acl: 'public-read-write' },
      { key: 'vr-slide-uploads-staging', acl: 'public-read-write' },
      { key: 'vr-staging-import' },
      { key: 'vr-staging-logs' },
      { key: 'vr-staging-media' },
      { key: 'vr-staging-images', location: 'eu-central-1' },
      { key: 'vr-staging-recordings', location: 'eu-central-1' },
      # live
      { key: 'vr-audio-uploads-live', acl: 'public-read-write' },
      { key: 'vr-slide-uploads-live', acl: 'public-read-write' },
      { key: 'vr-live-import' },
      { key: 'vr-live-logs' },
      { key: 'vr-live-media' },
      { key: 'vr-live-images', location: 'eu-central-1' },
      { key: 'vr-live-recordings', location: 'eu-central-1' }
    ]

    buckets.each do |bucket|
      next if bucket_names.include?(bucket[:key])
      puts "-> Creating #{bucket.inspect}"
      aws.directories.create(bucket)
    end


    rogue_buckets = bucket_names - buckets.map { |b| b[:key] }

    if !rogue_buckets.empty?
      puts
      puts "What's up with these?"
      puts
      puts *rogue_buckets
      puts
    end

  end

end


def aws
  return @aws unless @aws.nil?

  config = access_key = secret_key = nil

  s3cmd_path = File.join(ENV['HOME'], '.s3cfg')
  awscli_path = File.join(ENV['HOME'], '.aws', 'credentials')

  if File.exist?(s3cmd_path)
    config = IniFile.load(s3cmd_path)
    access_key = config['default']['access_key']
    secret_key = config['default']['secret_key']
  elsif File.exist?(awscli_path)
    config = IniFile.load(awscli_path)
    access_key = config['default']['aws_access_key_id']
    secret_key = config['default']['aws_secret_access_key']
  else
    raise "could read neither #{s3cmd_path} nor #{awscli_path}"
  end

  @aws = Fog::Storage.new(provider: 'AWS',
                          aws_access_key_id: access_key,
                          aws_secret_access_key: secret_key,
                          region: 'eu-central-1')
end
