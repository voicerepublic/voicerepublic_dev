FactoryGirl.define do
  factory :klu do

    description Faker::Lorem.paragraphs(2).join("\n")
    available_at_times "always when online"
    user
    category
    currency 'EUR'
    charge_amount 0

    sequence :title do |t|
      "#{Faker::Lorem.sentence} #{t}"
    end
  end
end