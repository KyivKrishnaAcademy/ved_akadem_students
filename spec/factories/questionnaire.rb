FactoryGirl.define do
  factory :questionnaire do
    title_uk  { Faker::Lorem.phrase }
    title_ru  { Faker::Lorem.phrase }
    questions { [build(:question)] }
  end
end
