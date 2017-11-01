FactoryGirl.define do
  factory :examination_result do
    examination
    student_profile

    score 1
  end
end
