FactoryGirl.define do
  factory :classroom do
    title     { FFaker::Lorem.word }
    roominess { 10 }
  end
end
