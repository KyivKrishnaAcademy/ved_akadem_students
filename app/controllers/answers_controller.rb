class AnswersController < HtmlResponsableController
  before_action :set_questionnaire

  after_action :verify_authorized, :verify_policy_scoped

  def edit
    authorize @questionnaire, :show_form?

    @questionnaire.questions.each { |q| q.answers.find_or_initialize_by(person: current_person) }
  end

  def update
    authorize @questionnaire, :save_answers?

    AnswersProcessorService.new(@questionnaire, current_person).process! if @questionnaire.update(questionnaire_params)

    respond_with(@questionnaire) do |format|
      format.html { redirect_to root_path }
    end
  end

  private

  def set_questionnaire
    @questionnaire = policy_scope(Questionnaire).find(params[:id])
  end

  def questionnaire_params
    params.require(:questionnaire).permit(
      questions_attributes: [:id, answers_attributes: [:id, :person_id, :data]]
    )
  end
end
