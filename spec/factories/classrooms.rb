FactoryGirl.define do
  factory :classroom do
    title     { Faker::Lorem.word }
    roominess { 10 }
  end
end
