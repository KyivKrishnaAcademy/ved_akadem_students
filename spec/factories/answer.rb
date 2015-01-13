FactoryGirl.define do
  factory :answer do
    person
    question
    data { [(1..100).to_a.sample.to_s, Faker::Lorem.sentence].sample }
  end

  trait :single_select_answer do
    data { (1..100).to_a.sample.to_s }
  end

  trait :freeform_answer do
    data { Faker::Lorem.sentence }
  end
end
