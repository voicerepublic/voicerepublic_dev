namespace :migrate do

  task listeners: :environment do
    query = Talk.where.not(listeners_legacy: nil)
    total = query.count
    query.each_with_index do |talk, index|
      print '%s/%s Migrating %s listeners from Talk %s (%s)' %
           [index+1, total, talk.listeners_legacy.length, talk.id, talk.title]
      talk.listeners_legacy.each do |session, time|
        time = DateTime.strptime(time.to_s,'%s')
        talk.listeners.create session_token: session, created_at: time
        print '.'
      end
      talk.update_attribute :listeners_legacy, nil
      puts
    end
    puts 'Total listeners: %s' % Listener.count
  end

end
