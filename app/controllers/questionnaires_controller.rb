class QuestionnairesController < HtmlRespondableController
  include Crudable

  def index
    @questionnaires = Questionnaire.order(:id)

    authorize Questionnaire

    respond_with(@questionnaires)
  end

  def show
    @programs = @questionnaire.programs.order(visible: :desc, position: :asc)
    @questions = @questionnaire.questions.order(:position)

    respond_with(@questionnaire)
  end

  private

  def set_resource
    @questionnaire = Questionnaire.find(params[:id])

    authorize @questionnaire
  end
end
