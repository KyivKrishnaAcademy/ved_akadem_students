FactoryGirl.define do
  psycho_test     = YAML.load_file(Rails.root.join('spec/fixtures/questionnaires/psyho_test_2.yml'))
  psycho_options  = { ru: psycho_test[:answers][:ru].to_a.map(&:reverse),
                      uk: psycho_test[:answers][:uk].to_a.map(&:reverse) }

  factory :questionnaire do
    title_uk  { Faker::Lorem.phrase }
    title_ru  { Faker::Lorem.phrase }
    questions { [build(:question)] }

    trait :psycho_test do
      kind      { 'psycho_test' }
      rule      { {keys: psycho_test[:keys], indexes: psycho_test[:indexes]} }
      questions { psycho_test[:questions].first(11).map do |q|
                    build(:question, :single_select,
                          position:  q[:position],
                          data:      {  text:       { uk: q[:question_uk],
                                                      ru: q[:question_ru] },
                                        options:    psycho_options,
                                        key:        q[:key],
                                        key_anwers: q[:key_answers].map(&:to_s) })
                  end
                }
    end
  end
end
