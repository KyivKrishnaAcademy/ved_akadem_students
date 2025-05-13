def deep_symbolize(obj)
  case obj
  when Hash
    obj.each_with_object({}) do |(k, v), memo|
      memo[k.respond_to?(:to_sym) ? k.to_sym : k] = deep_symbolize(v)
    end
  when Array
    obj.map { |e| deep_symbolize(e) }
  else
    obj
  end
end

FactoryBot.define do
  psycho_test     = deep_symbolize(
    YAML.safe_load(
      File.read(Rails.root.join('spec/fixtures/questionnaires/psyho_test_2.yml')),
      permitted_classes: [Symbol],
      aliases: true
    )
  )
  psycho_options  = {
    ru: psycho_test[:answers][:ru].to_a.map(&:reverse),
    uk: psycho_test[:answers][:uk].to_a.map(&:reverse)
  }

  initial_questions = YAML.load_file(Rails.root.join('spec/fixtures/questionnaires/initial_questions.yml'))

  factory :questionnaire do
    title_uk  { FFaker::Lorem.phrase }
    title_ru  { FFaker::Lorem.phrase }
    questions { [build(:question)] }

    trait :psycho_test do
      kind      { 'psycho_test' }
      rule      { { 'keys' => psycho_test.dig(:keys), 'indexes' => psycho_test.dig(:indexes) } }

      questions do
        psycho_test[:questions].first(11).map do |q|
          build(
            :question,
            :single_select,
            position:  q[:position],
            data: {
              text: {
                uk: q[:question_uk],
                ru: q[:question_ru]
              },
              options:    psycho_options,
              key:        q[:key],
              key_anwers: q[:key_answers].map(&:to_s)
            }
          )
        end
      end
    end

    trait :initial do
      kind         { 'initial_questions' }
      title_uk     { initial_questions[:title_uk] }
      title_ru     { initial_questions[:title_ru] }

      questions    do
        initial_questions[:questions].map do |q|
          build(
            :question,
            :freeform,
            position: q[:position],
            data: { text: { uk: q[:question_uk], ru: q[:question_ru] } }
          )
        end
      end
    end
  end
end
