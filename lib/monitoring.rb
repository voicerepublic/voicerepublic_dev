module Monitoring

  extend self

  def start
    # monitoring spawns it's own bunny
    bunny = BunnyWrapper.new

    # Subscribe to all of Rails' notifications and publish to an
    # exchange on RabbitMQ. Publishing to an exchange means, that if
    # nobody is listending RabbitMQ will discard these messages
    # instantly. Much like it would be the case if we'd use Faye for it.
    ActiveSupport::Notifications.subscribe(//) do |*args|

      # TODO cleanup args
      # * some content of `args` is not proper serializable
      # * this leads to lots of stack traces in unicorn.stderr.log
      # * with error messages like: "app error: not opened for reading (IOError)"

      data = args.last

      # visual should be a one line representation of the event
      visual =
        case args.first # name

        # generic notifications
        when 'sql.active_record'
          "[%s] %s" % [ data[:name],
                        data[:sql].split("\n").map(&:strip) * ' ' ]

        when 'instantiation.active_record'
          "%s * %s" % [ data[:record_count],
                        data[:class_name] ]

        when 'load_config_initializer.railties'
          data[:initializer].sub(Rails.root.to_s, '')

        when '!render_template.action_view',
             '!compile_template.action_view'
          data[:virtual_path]

        when 'render_template.action_view'
          data[:layout]

        when 'render_partial.action_view'
          data[:identifier].sub(Rails.root.to_s, '')

        when 'render_collection.action_view'
          "%s %s" % [ data[:identifier].sub(Rails.root.to_s, ''),
                      data[:count] ]

        when 'process_action.action_controller',
             'start_processing.action_controller'
          "%s %s %s %s %s#%s" % [ data[:method],
                                  data[:path],
                                  data[:format],
                                  data[:status],
                                  data[:controller],
                                  data[:action] ]

        # custom notifications
        when 'flyer.inkscape.vr'
          data[:cmd]

        when 'run_chain.audio_process.vr'
          data[:chain] * ' '

        # fall back to json for unknown events
        else data.to_json
        end

      duration = (args[2] - args[1]) * 1000

      params = [
        # custom arguments
        :exchange, :duration, :visual,
        # standard arguments
        :name, :started, :finished, :unique_id, :data
      ]

      # and send it to rabbitmq
      bunny.publish(Hash[params.zip(args.unshift('metrics', duration, visual))])
    end
  end
end
