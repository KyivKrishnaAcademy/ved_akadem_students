FactoryBot.define do
  factory :examination do
    course

    title { FFaker::Lorem.words(2).join(' ') }
    max_result {1}
    min_result {1}
    description { FFaker::Lorem.sentence }
    passing_score {1}
  end
end
