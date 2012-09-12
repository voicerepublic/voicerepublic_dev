# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :klu_image do
    description { Faker::Lorem.paragraph }
    kluuu
    image { File.open( File.join(Rails.root,'app','assets', 'images', 'rails.png'))}
  end
end
