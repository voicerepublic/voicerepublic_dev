require 'inifile'

namespace :fog do

  desc 'create s3 buckets and set permissions'
  task setup: :environment do

    config = access_key = secret_key = nil

    s3cmd_path = File.join(ENV['HOME'], '.s3cfg')
    awscli_path = File.join(ENV['HOME'], '.aws', 'credentials')

    if File.exist?(s3cmd_path)
      config = IniFile.load(s3cmd_path)
      access_key = config['default']['access_key']
      secret_key = config['default']['secret_key']
    elsif File.exist?(awscli_path)
      config = IniFile.load(s3cmd_path)
      access_key = config['default']['aws_access_key_id']
      secret_key = config['default']['aws_secret_access_key']
    else
      raise "could not read #{path}"
    end

    AWS = Fog::Storage.new(provider: 'AWS',
                           aws_access_key_id: access_key,
                           aws_secret_access_key: secret_key)

    bucket_names = AWS.directories.all.map(&:key)

    buckets = [
      # dev
      { key: 'vr-audio-uploads-dev', acl: 'public-read-write' },
      { key: 'vr-slide-uploads-dev', acl: 'public-read-write' },
      { key: 'vr-dev-import' },
      { key: 'vr-dev-logs' },
      { key: 'vr-dev-media' },
      # staging
      { key: 'vr-audio-uploads-staging', acl: 'public-read-write' },
      { key: 'vr-slide-uploads-staging', acl: 'public-read-write' },
      { key: 'vr-staging-import' },
      { key: 'vr-staging-logs' },
      { key: 'vr-staging-media' }
      # TODO if all turns out to be fine, uncomment these
      # live
      # { key: 'vr-audio-uploads-live', acl: 'public-read-write' },
      # { key: 'vr-slide-uploads-live', acl: 'public-read-write' },
      # { key: 'vr-live-import' },
      # { key: 'vr-live-logs' },
      # { key: 'vr-live-media' }
    ]

    buckets.each do |bucket|
      puts "Creating #{bucket.inspect}"
      AWS.directories.create(bucket)
    end


    rogue_buckets = bucket_names - buckets.map { |b| b[:key] }

    if !rogue_buckets.empty?
      puts "What's up with these?"
      puts *rogue_buckets
      puts
      rogue_buckets.each do |b|
        #AWS.directories.create key: "DELETE_ME_"+b
        #aws s3api get-bucket-location --bucket vr-poc
        #puts "aws s3 mv s3://#{b} s3://DELETE_ME_#{b} --recursive"
        #puts "aws s3 rb s3://#{b}"
        #puts "aws s3 rb s3://#{b} --recursive"
      end
      puts
    end

    # AWS.directories.create key: 'vr-test-acl', acl: 'public-read-write'
    # AWS.directories.new(key: 'vr-test-acl').destroy

    template = "% -40s % -20s % -20s"

    # TODO it down not show the acl, why?
    AWS.directories.all.each do |bucket|
      puts template % [bucket.key, bucket.location, bucket.acl]
    end


  end

end
