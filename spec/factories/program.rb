FactoryGirl.define do
  factory :program do
    title_ua       { Faker::Lorem.words(2).join(' ') }
    title_ru       { Faker::Lorem.words(2).join(' ') }
    description_ua { Faker::Lorem.sentence }
    description_ru { Faker::Lorem.sentence }
  end
end
