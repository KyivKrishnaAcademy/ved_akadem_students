FactoryGirl.define do
  factory :academic_group do
    sequence(:group_name, 1 ) do |n|
      nn = n % 1000
      "ШБ#{('%03d' % (nn == 0 ? nn + 1 : nn)).insert(2, '-')}"
    end
    group_description         { generate(:char_sequence)*10 }
    establ_date               Date.today
  end
end
