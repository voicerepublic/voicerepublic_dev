# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :page do
    slug "MyString"
    template "MyString"
    title_en "MyString"
    title_de "MyString"
    content_en "MyText"
    content_de "MyText"
  end
end
