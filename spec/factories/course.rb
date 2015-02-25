FactoryGirl.define do
  factory :course do
    name        { Faker::Lorem.words(2).join(' ') }
    description { Faker::Lorem.sentence }
  end
end
