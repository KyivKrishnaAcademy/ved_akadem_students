class AnswersProcessor
  def initialize(questionnaire, person)
    @questionnaire  = questionnaire
    @person         = person
  end

  def process!
    complete!
    compute_results!
  end

  private

    def complete!
      questionnaire_completeness.update_column(:completed, true)
    end

    def compute_results!
      result = {}

      answers = Answer.includes(:question).where(person_id: @person.id, questions: { questionnaire_id: @questionnaire.id })

      return if answers.none?

      if @questionnaire.kind == 'psycho_test'
        answers_by_keys     = Hash.new(0)
        answers_to_consider = Hash.new(0)

        answers.each do |answer|
          answers_by_keys[answer.question.data[:key]]     += 1
          answers_to_consider[answer.question.data[:key]] += 1 if answer.question.data[:key_anwers].include?(answer.data)
        end

        @questionnaire.rule[:keys].each do |key, value|
          max         = answers_by_keys[key] * value[:multiplier]
          current     = answers_to_consider[key] * value[:multiplier]
          percentage  = current * 100 / max

          result[key] = { ru: value[:ru],
                          uk: value[:uk],
                          max: max,
                          color: progressbar_color_class(percentage),
                          current: current,
                          percentage: percentage }
        end

        ai_max        = (result[1][:max] + result[2][:max] + result[3][:max])/3
        ai_current    = (result[1][:current] + result[2][:current] + result[3][:current])/3
        ai_percentage = ai_current * 100 / ai_max

        result[9] = { ru: @questionnaire.rule[:indexes][:ai][:ru],
                      uk: @questionnaire.rule[:indexes][:ai][:uk],
                      max: ai_max,
                      color: progressbar_color_class(ai_percentage),
                      current: ai_current,
                      percentage: ai_percentage }

        oi_max        = (result[6][:max] + result[7][:max])/2
        oi_current    = (result[6][:current] + result[7][:current])/2
        oi_percentage = oi_current * 100 / oi_max

        result[10] = { ru: @questionnaire.rule[:indexes][:oi][:ru],
                      uk: @questionnaire.rule[:indexes][:oi][:uk],
                      max: oi_max,
                      color: progressbar_color_class(oi_percentage),
                      current: oi_current,
                      percentage: oi_percentage }
      end

      questionnaire_completeness.update_column(:result, result)
    end

    def progressbar_color_class(percentage)
      if percentage <= 25
        'success'
      elsif percentage <= 50
        'info'
      elsif percentage <= 75
        'warning'
      else
        'danger'
      end
    end

    def questionnaire_completeness
      @questionnaire_completeness ||= QuestionnaireCompleteness.find_by(person: @person, questionnaire: @questionnaire)
    end
end
