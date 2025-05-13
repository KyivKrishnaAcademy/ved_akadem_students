FactoryBot.define do
  factory :role do
    activities { ['some:show'] }
    name       { generate(:char_sequence) * 10 }

    trait :super_admin do
      name       { 'all' }
      activities { all_activities }
    end
  end
end
