FactoryBot.define do
  factory :person do
    gender                      { true }
    middle_name                 { "Y#{generate(:char_sequence)}" }
    name                        { "V#{generate(:char_sequence)}" }
    password                    { 'password' }
    password_confirmation       { 'password' }
    privacy_agreement           { 'yes' }
    sequence(:birthday, 12_000) { |n| n.days.ago.to_date }
    sequence(:email)            { |n| "mail#{n}@ukr.net" }
    surname                     { "N#{generate(:char_sequence)}" }
    telephones                  { [build(:telephone)] }
    tokens                      { {} }
    roles                       { [] }
  end

  trait :admin do
    sequence(:email) { "admin@example.com" }
    middle_name      { 'Adminovich' }
    name             { 'Admin' }
    roles            { [FactoryBot.create(:role, :super_admin)] }
    surname          { 'Adminov' }
    telephones       { [build(:telephone, phone: '+380 50 111 2233')] }
  end

  trait :with_photo do
    photo { Rails.root.join('spec/fixtures/150x200.png').open }
  end

  trait :student do
    student_profile { FactoryBot.create(:student_profile) }
  end

  trait :teacher do
    teacher_profile { FactoryBot.create(:teacher_profile) }
  end
end