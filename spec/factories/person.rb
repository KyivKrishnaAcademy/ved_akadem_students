FactoryGirl.define do
  factory :person do
    gender                              { true }
    password                            { 'password' }
    password_confirmation               { 'password' }
    sequence(:telephone, 100000000000 ) { |n| "#{n}" }
    spiritual_name                      { "Ad#{generate(:char_sequence)} das" }
    name                                { "V#{generate(:char_sequence)}"      }
    middle_name                         { "Y#{generate(:char_sequence)}"      }
    surname                             {  "N#{generate(:char_sequence)}"     }
    sequence(:email                   ) { |n| "mail#{n}@ukr.net"      }
    sequence(:birthday ,        12000 ) { |n| n.days.ago.to_date      }
    edu_and_work                        { generate(:char_sequence)*20 }
  end

  trait :admin do
    roles           { [FactoryGirl.create(:role, :super_admin)] }
    email           { 'admin@example.com' }
    name            { 'Admin' }
    middle_name     { 'Adminovich' }
    surname         { 'Adminov' }
    spiritual_name  { 'Admin Prabhu' }
    telephone       { '199999999999' }
  end
end
