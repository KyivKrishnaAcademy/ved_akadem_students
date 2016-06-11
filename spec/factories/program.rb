FactoryGirl.define do
  factory :program do
    title_uk        { Faker::Lorem.words(2).join(' ') }
    title_ru        { Faker::Lorem.words(2).join(' ') }
    description_uk  { Faker::Lorem.sentence }
    description_ru  { Faker::Lorem.sentence }
    visible         { true }
    manager         { build :person }
  end
end
