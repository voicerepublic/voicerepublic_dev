namespace :fix do
  task all: [:language, :storage]

  task language: :environment do
    Talk.where(language: nil).each do |talk|
      talk.update_column :language, 'en'
    end
  end

  task storage: :environment do
    Talk.where(storage: nil).each do |talk|
      talk.update_column :storage, {}
    end
  end
end
