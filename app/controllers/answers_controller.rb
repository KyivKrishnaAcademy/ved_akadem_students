class AnswersController < ApplicationController
  respond_to :html

  before_action :set_questionnaire

  after_action :verify_authorized, :verify_policy_scoped

  def edit
    authorize @questionnaire, :show_form?

    @questionnaire.questions.each { |q| q.answers.find_or_initialize_by(person: current_person) }
  end

  def update
    authorize @questionnaire, :save_answers?

    AnswersProcessorService.new(@questionnaire, current_person).process! if @questionnaire.update(questionnaire_params)
    # TODO: check the location on failure
    respond_with(@questionnaire, location: root_path)
  end

  private

  def set_questionnaire
    @questionnaire = policy_scope(Questionnaire).find(params[:id])
  end

  def questionnaire_params
    params.require(:questionnaire).permit(
      questions_attributes: [:id, answers_attributes: %i[id person_id data]]
    )
  end
end
