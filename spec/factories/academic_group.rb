FactoryGirl.define do
  factory :academic_group do
    sequence(:title, 1) do |n|
      nn = n % 1000

      "ШБ#{format('%03d', nn.zero? ? nn.next : nn).insert(2, '-')}"
    end

    establ_date       { Time.zone.today }
    administrator     { create :person }
    group_description { generate(:char_sequence) * 10 }
  end
end
