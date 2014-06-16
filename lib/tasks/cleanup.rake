namespace :cleanup do
  desc 'Delete guest users that are no longer active'
  task :guests => :environment do
    User.where('firstname like ?', '%guest%').
      where('last_request_at < ?', 4.hours.ago).destroy_all
  end

  desc 'Regenerate all flyers'
  task :guests => :environment do
    Talk.all.each { |t| t.send(:generate_flyer) }
  end

  # When a talk has been created, but the host never shows, the talk will never
  # proceed to further states. For the time being, this is corrected here.
  # TODO: Maybe it's better to implement an additional state machine state
  # 'abandoned'
  desc 'Set abandoned talks(host never showed up) to state postlive'
  task :fix_abandoned_talk_state => :environment do
    Talk.prelive.where("ends_at < ?", DateTime.now).each do |t|
      t.update_attribute :state, :postlive
      t.save!
    end
  end

  # TODO this should be more generic and move into `trickery`
  # TODO does this deprecate `db:data:validate`?
  desc 'Check validity of talks, series and user profiles'
  task :check_validity => :environment do

    class InvalidModelException < Exception
      def initialize(msg)
        @msg = msg
      end
    end

    errors_count = 0
    error_ids = {
      talks: [],
      series: [],
      users: [],
    }
    ressources = [ [Talk, :talks], [Venue, :series], [User, :users]]

    ressources.each do |model, key|
      model.all.each do |m|
        unless m.valid?
          error_ids[key] << [ "#{m.id.to_i}", m.errors.full_messages ]
          errors_count += 1
        end
      end
    end

    if errors_count > 0
      puts error_ids
      msg = { invalid_models: error_ids, errors_count: errors_count }
      Rails.logger.warn "====\nInvalid models: #{errors_count}."
      Rails.logger.warn msg.to_s + "\n===="
      raise InvalidModelException.new msg
    end
  end

  task fix_blank_descriptions: :environment do
    Talk.where(description: '').each do |talk|
      talk.update_attribute :description, '<i>blank description</i>'
    end
  end
end
