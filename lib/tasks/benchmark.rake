namespace :akadem do
  desc 'run benchmarks'
  task benchmark: :environment do
    system('rake akadem:benchmarks:include_or_join_distinct RAILS_ENV=test')
  end

  namespace :benchmarks do
    task include_or_join_distinct: :environment do
      require 'benchmark'

      include FactoryGirl::Syntax::Methods

      iterations = 1_000

      person_1 = create :person
      person_2 = create :person
      person_3 = create :person

      questionnaire_1 = create :questionnaire
      questionnaire_2 = create :questionnaire
      questionnaire_3 = create :questionnaire
      questionnaire_4 = create :questionnaire
      questionnaire_5 = create :questionnaire
      questionnaire_6 = create :questionnaire

      person_1.questionnaire_completenesses.create(completed: true , questionnaire_id: questionnaire_1.id)
      person_1.questionnaire_completenesses.create(completed: false, questionnaire_id: questionnaire_2.id)
      person_1.questionnaire_completenesses.create(completed: false, questionnaire_id: questionnaire_3.id)

      person_2.questionnaire_completenesses.create(completed: false, questionnaire_id: questionnaire_1.id)
      person_2.questionnaire_completenesses.create(completed: true , questionnaire_id: questionnaire_2.id)
      person_2.questionnaire_completenesses.create(completed: true , questionnaire_id: questionnaire_4.id)

      person_3.questionnaire_completenesses.create(completed: false, questionnaire_id: questionnaire_1.id)
      person_3.questionnaire_completenesses.create(completed: false, questionnaire_id: questionnaire_2.id)
      person_3.questionnaire_completenesses.create(completed: false, questionnaire_id: questionnaire_5.id)
      person_3.questionnaire_completenesses.create(completed: false, questionnaire_id: questionnaire_6.id)

      Benchmark.bm(25) do |b|

        b.report('includes') do
          iterations.times do
            person_2.questionnaires.includes(:questionnaire_completenesses).
                where(questionnaire_completenesses: { completed: false })
          end
        end

        b.report('joins distinct') do
          iterations.times do
            person_2.questionnaires.joins(:questionnaire_completenesses).
                                    where(questionnaire_completenesses: { completed: false }).
                                    distinct
          end
        end

        b.report('joins distinct order') do
          iterations.times do
            person_2.questionnaires.joins(:questionnaire_completenesses).
                                    where(questionnaire_completenesses: { completed: false }).
                                    distinct.order(:id)
          end
        end
      end
    end
  end
end
