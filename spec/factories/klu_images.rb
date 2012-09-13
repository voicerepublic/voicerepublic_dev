# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :klu_image do
    description { Faker::Lorem.paragraph }
    kluuu
    image { fixture_file_upload(File.join(Rails.root,'app','assets', 'images', 'rails.png'))}
  end
end
