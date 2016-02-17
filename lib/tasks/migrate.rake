def call_and_save(klass, methods)
  methods = [methods] unless methods.is_a?(Array)
  total = klass.count
  index = 0
  klass.find_each do |resource|
    index += 1
    print '%s/%s %s %s ' % [index, total, klass.name, resource.id]
    methods.each do |method|
      resource.send(method)
    end
    puts resource.save ? 'ok' : 'failed'
  end
end

namespace :migrate do

  namespace :text do
    desc 'populate all _as_text fields'
    task all: [:talks, :series, :users]

    desc 'populate talks#description_as_text'
    task talks: :environment do
      call_and_save(Talk, :process_description)
    end

    desc 'populate series#description_as_text'
    task series: :enironment do
      call_and_save(Series, :process_description)
    end

    desc 'populate user#about_as_text'
    task users: :environment do
      call_and_save(User, :process_about)
    end
  end

end
