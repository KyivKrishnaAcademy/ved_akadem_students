FactoryGirl.define do
  factory :certificate do
    assigned_cert_template
    sequence(:cert_id) { |n| "1-1-#{n}" }
    student_profile
  end
end
