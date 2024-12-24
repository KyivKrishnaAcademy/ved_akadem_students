FactoryBot.define do
  factory :telephone do
    sequence(:phone, 1_000_000) { |n| "+380 50 #{n.to_s.insert(3, ' ')}" }
  end
end
