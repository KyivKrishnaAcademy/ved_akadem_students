FactoryGirl.define do
  factory :questionnaire do
    title     { Faker::Lorem.phrase }
    questions { [build(:question)] }
  end
end
