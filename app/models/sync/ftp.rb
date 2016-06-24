# A generic solution for polling s3ftp and dispatching overrides. It's
# supposed to be run via cron. From `config/schedule.rb`:
#
#   every 1.minute, roles: [:app] do
#     runner 'Sync::Ftp.poll("log/rp16.yml")'
#   end
#
# On rails console test with
#
#   reload!; Sync::Ftp.poll('rp16.yml', dryrun: true)
#
module Sync
  class Ftp
    class << self

      NAME_REGEX = /^(\d+)\.mp3$/

      DEFAULTS = {
        'bucket' => 'vr-ftp-files',
        'prefix' => 'rp16'
      }

      def poll(index_file, opts={})
        # init
        unless File.exist?(index_file)
          puts "create #{index_file}" if opts[:dryrun]
          File.open(index_file, 'w') { |f| f.puts YAML.dump(DEFAULTS) }
        end

        # load
        puts "read #{index_file}" if opts[:dryrun]
        config = YAML.load(File.read(index_file))
        pp config if opts[:dryrun]
        index = config['index'] || {}

        # query
        options = {
          provider: 'AWS',
          aws_access_key_id: 'AKIAIGKSA6ESEFZV4DQA',
          aws_secret_access_key: '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',
          region: 'eu-central-1'
        }
        storage = Fog::Storage.new(options)
        bucket = storage.directories.new(key: config['bucket'])

        # analyze
        bucket.files.each do |file|
          name = file.key
          size = file.content_length

          puts '%-20s %-20s' % [name, size] if opts[:dryrun]

          if index[name]
            puts "known" if opts[:dryrun]
            if index[name]['size'] == size
              puts "same size" if opts[:dryrun]
              if index[name]['state'] != 'dispatched'
                puts "not yet dispatched" if opts[:dryrun]

                # build uri
                uri = index[name]['uri'] = file.url(2.days.from_now)

                # find talk
                _, nid = name.match(NAME_REGEX).to_a
                talk_uri = '%s-%s' % [config['prefix'], nid]
                index[name]['uri'] = talk_uri
                talk = Talk.find_by(uri: talk_uri)
                if talk.nil?
                  msg = "Could not find talk with uri #{talk_uri} "+
                        "for ftp file '#{name}'"
                  Rails.logger.fatal msg
                  puts msg
                  next
                end
                index[name]['id'] = talk.id

                if opts[:dryrun]
                  puts "dispatch override for %s with %s" % [talk.id, uri]
                  next
                end

                # dispatch override
                talk.update_attribute :recording_override, uri.to_s
                Delayed::Job.enqueue ProcessOverride.new(id: talk.id), queue: 'audio'
                index[name]['state'] = 'dispatched'
              end
            else
              puts "size differs" if opts[:dryrun]
              index[name]['size'] = size
              index[name]['state'] = 'growing'
            end
          else
            puts "new" if opts[:dryrun]
            index[name] ||= { 'state' => 'new', 'size' => size }
          end
        end

        # save
        config['index'] = index
        config['touch'] = Time.now
        pp config if opts[:dryrun]
        File.open(index_file, 'w') { |f| f.puts(YAML.dump(config)) }
      end
    end

  end
end
