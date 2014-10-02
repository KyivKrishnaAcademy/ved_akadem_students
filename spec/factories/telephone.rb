FactoryGirl.define do
  factory :telephone do
    sequence(:phone, 1000000000 ) { |n| n.to_s.insert(-5, '-').insert(-3, '-').insert(3, ') ').insert(0, '(') }
  end
end
