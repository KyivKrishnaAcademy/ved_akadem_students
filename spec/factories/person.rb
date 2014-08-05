FactoryGirl.define do
  factory :person do
    gender                              true
    password                            'password'
    password_confirmation               'password'
    sequence(:telephone, 100000000000 ) { |n| "#{n}"                     }
    sequence(:spiritual_name          ) { |n| "Ad#{generate(:char_sequence)} das"  }
    sequence(:name                    ) { |n| "V#{generate(:char_sequence)}"       }
    sequence(:middle_name             ) { |n| "Y#{generate(:char_sequence)}"       }
    sequence(:surname                 ) { |n| "N#{generate(:char_sequence)}"       }
    sequence(:email                   ) { |n| "mail#{n}@ukr.net"         }
    sequence(:birthday ,        12000 ) { |n| n.days.ago.to_date         }
    edu_and_work                        { generate(:char_sequence)*20              }
  end
end