FactoryGirl.define do
  factory :person do
    education                   { generate(:char_sequence) * 20 }
    gender                      { true }
    middle_name                 { "Y#{generate(:char_sequence)}" }
    name                        { "V#{generate(:char_sequence)}" }
    password                    { 'password' }
    password_confirmation       { 'password' }
    privacy_agreement           { 'yes' }
    sequence(:birthday, 12_000) { |n| n.days.ago.to_date }
    sequence(:email)            { |n| "mail#{n}@ukr.net" }
    spiritual_name              { "Ad#{generate(:char_sequence)} das" }
    surname                     { "N#{generate(:char_sequence)}" }
    telephones                  { [build(:telephone)] }
    work                        { generate(:char_sequence) * 20 }
    marital_status              { 'single' }
    diksha_guru                 { 'Srila Prabhupada' }
  end

  trait :admin do
    email           { 'admin@example.com' }
    middle_name     { 'Adminovich' }
    name            { 'Admin' }
    roles           { [FactoryGirl.create(:role, :super_admin)] }
    spiritual_name  { 'Admin Prabhu' }
    surname         { 'Adminov' }
    telephones      { [build(:telephone, phone: '+380 50 111 2233')] }
  end

  trait :with_photo do
    photo { Rails.root.join('spec/fixtures/150x200.png').open }
  end

  trait :student do
    student_profile { FactoryGirl.create(:student_profile) }
  end

  trait :teacher do
    teacher_profile { FactoryGirl.create(:teacher_profile) }
  end
end
