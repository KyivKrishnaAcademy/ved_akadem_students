FactoryBot.define do
  factory :program do
    title_uk        { FFaker::Lorem.words(2).join(' ') }
    title_ru        { FFaker::Lorem.words(2).join(' ') }
    description_uk  { FFaker::Lorem.sentence }
    description_ru  { FFaker::Lorem.sentence }
    visible         { true }
    manager         { build :person }
  end
end
