FactoryGirl.define do
  factory :course do
    description { FFaker::Lorem.sentence }
    title       { FFaker::Lorem.words(2).join(' ') }
  end
end
