FactoryGirl.define do
  factory :course do
    description { Faker::Lorem.sentence }
    title       { Faker::Lorem.words(2).join(' ') }
  end
end
