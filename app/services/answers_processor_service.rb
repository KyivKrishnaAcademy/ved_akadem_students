class AnswersProcessorService
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
    result  = {}
    answers = Answer
                .includes(:question)
                .where(person_id: @person.id, questions: { questionnaire_id: @questionnaire.id })

    return if answers.none?

    result = compute_psycho_result(@questionnaire, answers) if @questionnaire.kind == 'psycho_test'

    questionnaire_completeness.update_column(:result, result)
  end

  def compute_psycho_result(questionnaire, answers)
    result = psycho_base_result(questionnaire, answers)

    ai_max        = average_result(result, (1..3), :max)
    ai_current    = average_result(result, (1..3), :current)
    result[9]     = index_result(questionnaire, :ai, ai_max, ai_current)

    oi_max        = average_result(result, (6..7), :max)
    oi_current    = average_result(result, (6..7), :current)
    result[10]    = index_result(questionnaire, :oi, oi_max, oi_current)

    result
  end

  def psycho_base_result(questionnaire, answers)
    answers_by_keys, answers_to_consider = count_psycho_answers(answers)

    result = {}

    questionnaire.rule[:keys].each do |key, value|
      max         = answers_by_keys[key] * value[:multiplier]
      current     = answers_to_consider[key] * value[:multiplier]
      percentage  = current * 100 / max

      result[key] = { ru: value[:ru], uk: value[:uk], max: max, color: progressbar_color_class(percentage),
                      current: current, percentage: percentage }
    end

    result
  end

  def count_psycho_answers(answers)
    answers_by_keys     = Hash.new(0)
    answers_to_consider = Hash.new(0)

    answers.each do |answer|
      answers_by_keys[answer.question.data[:key]]     += 1
      answers_to_consider[answer.question.data[:key]] += 1 if answer_matched?(answer)
    end

    [answers_by_keys, answers_to_consider]
  end

  def average_result(result, indexes, param)
    indexes.inject(0) { |a, e| a + result[e][param] } / indexes.size
  end

  def index_result(questionnaire, index_type, max, current)
    percentage = current * 100 / max

    { ru: questionnaire.rule[:indexes][index_type][:ru],
      uk: questionnaire.rule[:indexes][index_type][:uk],
      max: max,
      color: progressbar_color_class(percentage),
      current: current,
      percentage: percentage }
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

  def answer_matched?(answer)
    answer.question.data[:key_anwers].include?(answer.data)
  end
end
