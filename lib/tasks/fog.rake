# Naming convention for s3 buckets
#
#   <prefix>-<region>-<target>-<topic>
#
#   prefix: always 'vr'
#   region: should be 'euc1' for 'eu-central-1'
#   target: either of 'dev', 'staging', or 'live'
#   topic:  a name, which describes the purpose of the bucket
#

require 'inifile'

namespace :fog do

  BUCKETS = [
    # OLDSCHOOL
    # common
    { key: 'vr-ftp-files', location: 'eu-central-1' },
    { key: 'vr-maven-repo', location: 'eu-central-1' },
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
    { key: 'vr-live-recordings', location: 'eu-central-1' },

    # NEWSCHOOL
    { key: 'vr-euc1-dev-audio-uploads',      location: 'eu-central-1' },
    { key: 'vr-euc1-dev-import',             location: 'eu-central-1' },
    { key: 'vr-euc1-dev-logs',               location: 'eu-central-1' },
    { key: 'vr-euc1-dev-media',              location: 'eu-central-1' },
    { key: 'vr-euc1-dev-slides-uploads',     location: 'eu-central-1' },

    { key: 'vr-euc1-live-audio-uploads',     location: 'eu-central-1' },
    { key: 'vr-euc1-live-import',            location: 'eu-central-1' },
    { key: 'vr-euc1-live-logs',              location: 'eu-central-1' },
    { key: 'vr-euc1-live-media',             location: 'eu-central-1' },
    { key: 'vr-euc1-live-slides-uploads',    location: 'eu-central-1' },

    { key: 'vr-euc1-staging-audio-uploads',  location: 'eu-central-1' },
    { key: 'vr-euc1-staging-import',         location: 'eu-central-1' },
    { key: 'vr-euc1-staging-logs',           location: 'eu-central-1' },
    { key: 'vr-euc1-staging-media',          location: 'eu-central-1' },
    { key: 'vr-euc1-staging-slides-uploads', location: 'eu-central-1' }
  ]

  desc 'list all buckets'
  task list: :environment do

    template = "% -40s % -20s % -20s"

    aws.directories.all.each do |bucket|
      acl = nil # aws.get_bucket_acl(bucket.key).body
      puts template % [bucket.key, bucket.location, acl]
    end
  end

  desc 'move all buckets to europe'
  task :move do
    vector = "--source-region us-east-1 --region eu-central-1"
    cmd = "aws s3 sync s3://%s s3://%s %s"

    mapping = {
      'vr-audio-uploads-dev'     => 'vr-euc1-dev-audio-uploads',
      'vr-audio-uploads-live'    => 'vr-euc1-live-audio-uploads',
      'vr-audio-uploads-staging' => 'vr-euc1-staging-audio-uploads',
      'vr-dev-import'            => 'vr-euc1-dev-import',
      'vr-dev-logs'              => 'vr-euc1-dev-logs',
      'vr-dev-media'             => 'vr-euc1-dev-media',
      'vr-live-import'           => 'vr-euc1-live-import',
      'vr-live-logs'             => 'vr-euc1-live-logs',
      'vr-live-media'            => 'vr-euc1-live-media',
      'vr-slide-uploads-dev'     => 'vr-euc1-dev-slides-uploads',
      'vr-slide-uploads-live'    => 'vr-euc1-live-slides-uploads',
      'vr-slide-uploads-staging' => 'vr-euc1-staging-slides-uploads',
      'vr-staging-import'        => 'vr-euc1-staging-import',
      'vr-staging-logs'          => 'vr-euc1-staging-logs',
      'vr-staging-media'         => 'vr-euc1-staging-media'
    }

    mapping.each do |from, to|
      puts c = cmd % [from, to, vector]
      system c
    end
  end

  desc 'create s3 buckets and set permissions'
  task setup: :environment do

    bucket_names = aws.directories.all.map(&:key)

    BUCKETS.each do |bucket|
      next if bucket_names.include?(bucket[:key])
      puts "-> Creating #{bucket.inspect}"
      aws.directories.create(bucket)
    end


    rogue_buckets = bucket_names - BUCKETS.map { |b| b[:key] }

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
