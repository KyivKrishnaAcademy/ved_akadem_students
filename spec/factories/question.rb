FactoryGirl.define do
  factory :question do
    format  { %w[freeform single_select].sample }
    data    { { text: { uk: Faker::Lorem.sentence, ru: Faker::Lorem.sentence } } }
  end

  trait :boolean do
    format { 'single_select' }
  end

  trait :freeform do
    format { 'freeform' }
  end
end
