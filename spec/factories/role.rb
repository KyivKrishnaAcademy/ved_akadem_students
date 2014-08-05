FactoryGirl.define do
  factory :role do
    activities ['some:show']
    name       { generate(:char_sequence)*10 }
  end
end
