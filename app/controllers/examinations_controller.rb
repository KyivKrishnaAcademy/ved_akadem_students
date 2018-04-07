class ExaminationsController < HtmlRespondableController
  before_action :set_examination, only: %i[show edit update destroy]

  after_action :verify_authorized

  def show
    respond_with(@examination)
  end

  def new
    @examination = Examination.new(passing_score: 1, min_result: 0, max_result: 1, course_id: params[:course_id])

    authorize @examination

    respond_with(@examination)
  end

  def edit; end

  def create
    @examination = Examination.new(examination_params.merge(course_id: params[:course_id]))

    authorize @examination

    @examination.save

    respond_with(@examination, location: -> { course_examination_path(params[:course_id], @examination.id) })
  end

  def update
    @examination.update(examination_params)

    respond_with(@examination, location: -> { course_examination_path(params[:course_id], @examination.id) })
  end

  def destroy
    @examination.destroy

    respond_with(@examination, location: -> { course_path(params[:course_id]) })
  end

  private

  def set_examination
    @examination = Examination.find(params[:id])

    authorize @examination
  end

  def examination_params
    params.require(:examination).permit(:title, :description, :passing_score, :min_result, :max_result)
  end
end
