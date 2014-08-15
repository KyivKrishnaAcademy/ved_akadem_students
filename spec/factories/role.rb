FactoryGirl.define do
  factory :role do
    activities { ['some:show'] }
    name       { generate(:char_sequence)*10 }

    trait :super_admin do
      name       { 'all' }
      activities { PeopleController.action_methods.map { |action| 'person:' << action } - %w{person:show_photo} }
    end
  end
end
