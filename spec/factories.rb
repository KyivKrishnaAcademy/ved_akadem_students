FactoryGirl.define do
  sequence(:str) do |n|
    str = 'a'
    (n - 1).times { str.succ! }
    str
  end

  factory :person do
    gender                              true
    sequence(:telephone, 100000000000 ) { |n| "#{n}"                     }
    sequence(:spiritual_name          ) { |n| "Ad#{generate(:str)} das"  }
    sequence(:name                    ) { |n| "V#{generate(:str)}"       }
    sequence(:middle_name             ) { |n| "Y#{generate(:str)}"       }
    sequence(:surname                 ) { |n| "N#{generate(:str)}"       }
    sequence(:email                   ) { |n| "mail#{n}@ukr.net"         }
    sequence(:birthday ,        12000 ) { |n| n.days.ago.to_date         }
    edu_and_work                        { generate(:str)*20              }
  end

  factory :akadem_group do
    sequence(:group_name, 1 ) { |n|
                                nn = n % 1000
                                "ШБ#{("%03d" % (nn == 0 ? nn + 1 : nn)).insert(2, '-')}"
                              } # if n = 131 then "ШБ13-1"
    group_description         { generate(:str)*10 }
    establ_date               Date.today
  end
end