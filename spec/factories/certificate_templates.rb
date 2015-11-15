FactoryGirl.define do
  factory :certificate_template do
    sequence(:title)  { |n| "Some title ##{n}" }
    background        { Rails.root.join('spec/fixtures/150x200.png').open }
  end
end
