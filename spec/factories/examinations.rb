FactoryGirl.define do
  factory :examination do
    course

    title "MyString"
    description "MyText"
    passings_score 1
    min_result 1
    max_result 1
  end
end
