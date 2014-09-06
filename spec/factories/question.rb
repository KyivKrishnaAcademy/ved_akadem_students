FactoryGirl.define do
  factory :question do
    format  { %w[freeform boolean].sample }
    data    { { text: Faker::Lorem.sentence } }
  end
end
