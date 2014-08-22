FactoryGirl.define do
  factory :telephone do
    sequence(:phone, 1000000000 ) { |n| "#{n}" }
  end
end
