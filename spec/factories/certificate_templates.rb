FactoryGirl.define do
  factory :certificate_template do
    sequence(:title)  { |n| "Some title ##{n}" }
  end
end
