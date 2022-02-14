class AnswersController < ApplicationController
  respond_to :html

  before_action :set_questionnaire

  after_action :verify_authorized, :verify_policy_scoped

  def edit
    authorize @questionnaire, :show_form?

    set_questions
    set_answers_by_question_id
  end

  def update
    authorize @questionnaire, :save_answers?

    if @questionnaire.update(questionnaire_params)
      AnswersProcessorService.new(@questionnaire, current_person).process!
    else
      set_questions
      set_answers_by_question_id

      questionnaire_params[:questions_attributes].each_value do |q_attributes|
        @answers_by_question_id[q_attributes[:id].to_i].data = q_attributes[:answers_attributes].values.first[:data]
      end
    end

    respond_with(@questionnaire, location: root_path)
  end

  private

  def set_questionnaire
    @questionnaire = policy_scope(Questionnaire).find(params[:id])
  end

  def set_questions
    @questions = @questionnaire.questions.order(:position)
  end

  def set_answers_by_question_id
    persisted_answers_by_question_id = Answer
                                         .where(person: current_person, question_id: @questions.map(&:id))
                                         .to_a
                                         .index_by(&:question_id)

    @answers_by_question_id = @questions.map do |q|
      [q.id, persisted_answers_by_question_id[q.id] || Answer.new(question: q, person: current_person)]
    end.to_h
  end

  def questionnaire_params
    result = params.require(:questionnaire).permit(
      questions_attributes: [:id, { answers_attributes: %i[id person_id data] }]
    )

    result[:questions_attributes].each do |_k, v|
      v[:answers_attributes]['0'][:person_id] = current_person.id
    end

    result
  end
end
