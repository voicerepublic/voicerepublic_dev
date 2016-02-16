def migrate_text(klass, methods)
  methods = [methods] unless methods.is_a?(Array)
  total = klass.count
  index = 0
  klass.find_each do |resource|
    index += 1
    puts '%s/%s %s %s' % [index, total, klass.name, resource.id]
    methods.each do |method|
      resource.send(method)
    end
    resource.save
  end
end

namespace :migrate do

  namespace :text do
    desc 'populate all _as_text fields'
    task all: [:talks, :series, :users]

    desc 'populate talks#description_as_text'
    task :talks do
      migrate_text(Talk, :process_description)
    end

    desc 'populate series#description_as_text'
    task :series do
      migrate_text(Series, :process_description)
    end

    desc 'populate user#about_as_text'
    task :users do
      migrate_text(User, :process_about)
    end
  end

end
