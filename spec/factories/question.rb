FactoryGirl.define do
  factory :question do
    format  { %w[freeform boolean].sample }
    data    { { text: Faker::Lorem.sentence } }
  end

  trait :boolean do
    format { 'boolean' }
  end

  trait :freeform do
    format { 'freeform' }
  end
end
