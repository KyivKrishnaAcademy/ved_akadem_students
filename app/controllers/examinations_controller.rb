class ExaminationsController < HtmlRespondableController
  before_action :set_examination, only: %i[edit update destroy]

  after_action :verify_authorized

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

    respond_with(@examination, location: -> { course_path(@examination.course_id) })
  end

  def update
    @examination.update(examination_params)

    respond_with(@examination, location: -> { course_path(@examination.course_id) })
  end

  def destroy
    location = course_path(params[:course_id])

    if @examination.examination_results_count.positive?
      redirect_back(
        fallback_location: location,
        flash: {
          danger: t(
            'examinations.destroy.remove_examination_results_first',
            examination_results_count: @examination.examination_results_count
          )
        }
      )
    else
      @examination.destroy

      respond_with(@examination, location: -> { location })
    end
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
