namespace :validity do

  desc 'Check validity of talks, series and user profiles'
  task check: :environment do
    class InvalidModelsException < Exception; end
    report = { details: Hash.new { |h, k| h[k] = Hash.new { |i, l| i[l] = [] } },
               summary: Hash.new { |h, k| h[k] = {} } }

    Rails.application.eager_load!
    ActiveRecord::Base.descendants.each do |klass|
      plural = klass.model_name.plural
      puts "CHECKING #{klass.count} #{plural}"
      klass.find_each do |model|
        if model.valid?
          print '.'
        else
          print 'x'
          model.errors.full_messages.each do |message|
            report[:details][plural][message] |= [model.id]
          end
        end
      end
      puts
    end

    report[:details].each do |model, errors|
      errors.each do |error, ids|
        report[:summary][model][error] = ids.size
      end
    end

    raise(InvalidModelsException, report.to_yaml) if report[:details].present?

    puts "\nALL GOOD!\n"
  end

end
