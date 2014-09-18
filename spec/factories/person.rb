FactoryGirl.define do
  factory :person do
    gender                              { true }
    password                            { 'password' }
    password_confirmation               { 'password' }
    spiritual_name                      { "Ad#{generate(:char_sequence)} das" }
    name                                { "V#{generate(:char_sequence)}"      }
    middle_name                         { "Y#{generate(:char_sequence)}"      }
    surname                             {  "N#{generate(:char_sequence)}"     }
    sequence(:email                   ) { |n| "mail#{n}@ukr.net"      }
    sequence(:birthday ,        12000 ) { |n| n.days.ago.to_date      }
    education                           { generate(:char_sequence)*20 }
    work                                { generate(:char_sequence)*20 }
    telephones                          { [build(:telephone)] }
  end

  trait :admin do
    roles           { [FactoryGirl.create(:role, :super_admin)] }
    email           { 'admin@example.com' }
    name            { 'Admin' }
    middle_name     { 'Adminovich' }
    surname         { 'Adminov' }
    spiritual_name  { 'Admin Prabhu' }
    telephones      { [build(:telephone, phone: '199999999999')] }
  end

  trait :with_photo do
    photo { File.open("#{Rails.root}/spec/fixtures/150x200.png") }
  end

  trait :student do
    student_profile { FactoryGirl.create(:student_profile) }
  end

  trait :teacher do
    teacher_profile { FactoryGirl.create(:teacher_profile) }
  end
end
