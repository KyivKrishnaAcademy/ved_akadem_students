FactoryBot.define do
  factory :certificate_template do
    sequence(:title)  { |n| "Some title ##{n}" }
    institution { create(:institution) }
  end
end
