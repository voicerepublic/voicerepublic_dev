# A generic solution for polling ftps and dispatching overrides. It's
# supposed to be run via cron. From `config/schedule.rb`:
#
#   every 5.minutes, roles: [:app] do
#     runner 'Sync::Ftp.poll("rp16.yml")'
#   end
#
# On rails console test with
#
#   reload!; Sync::Ftp.poll('rp16.yml', dryrun: true)
#
module Sync
  class Ftp
    class << self

      # http://rubular.com/r/KbbUu4v5h0
      LINE_REGEX = /^[drwx-]+\s+\d+\s+\w+\s+\w+\s+(\d+)\s+\w+\s+\d+\s+[\d:]+\s+(.+)$/

      NAME_REGEX = /^(\d+)\.mp3$/

      DEFAULTS = {
        'prefix' => 'rp16',
        'user' => 'ftpuser',
        'pass' => 'realpubic',
        'url' => 'ftp://52.58.158.181/',
        'command' => 'wget %{options} %{url} && cat .listing',
        'options' => '--quiet --no-remove-listing --spider '+
                     '--user=%{user} --password=%{pass}'
      }

      def poll(index_file, opts={})
        # init
        unless File.exist?(index_file)
          File.open(index_file, 'w') { |f| f.puts YAML.dump(DEFAULTS) }
        end

        # load
        config = YAML.load(File.read(index_file))
        pp config if opts[:dryrun]
        index = config['index'] || {}

        # query
        options = config['options'] % { user: config['user'], pass: config['pass'] }
        command = config['command'] % { options: options, url: config['url'] }
        puts command if opts[:dryrun]
        output = %x[#{command}]
        puts output if opts[:dryrun]
        lines = output.split("\r\n")

        # analyze
        lines.each do |line|
          _, size, name = line.match(LINE_REGEX).to_a
          next if %w(. ..).include?(name)
          if index[name]
            if index[name]['size'] == size
              if index[name]['state'] != 'dispatched'
                index[name]['state'] = 'complete'
              end
            else
              index[name]['size'] = size
              index[name]['state'] = 'growing'
            end
          else
            index[name] ||= { 'state' => 'new', 'size' => size }
          end
        end

        pp index if opts[:dryrun]

        # dispatch override
        index.each do |name, details|
          next unless details['state'] == 'complete'

          # build uri
          uri = URI.parse(config['url']+URI.encode(name))
          uri.user = config['user']
          uri.password = config['pass']

          # find talk
          _, nid = name.match(NAME_REGEX).to_a
          talk_uri = '%s-%s' % [config['prefix'], nid]
          talk = Talk.find_by(uri: talk_uri)
          if talk.nil?
            Rails.logger.fatal "Could not find talk with uri #{talk_uri} "+
                               "for ftp file '#{name}'"
            next
          end

          if opts[:dryrun]
            puts "dispatch override for %s with %s" % [talk.id, uri]
            next
          end

          # dispatch override
          talk.update_attribute :recording_override, uri.to_s
          Delayed::Job.enqueue ProcessOverride.new(id: talk.id), queue: 'audio'
          details['state'] = 'dispatched'
        end

        # save
        config['index'] = index
        config['touch'] = Time.now
        File.open(index_file, 'w') { |f| f.puts(YAML.dump(config)) }
      end
    end

  end
end
