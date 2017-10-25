class CoursesController < HtmlRespondableController
  include Crudable
  include ClassSchedulesRefreshable

  after_action :refresh_class_schedules_mv, only: %i(destroy update)

  def index
    @courses = Course.order(:title)

    authorize Course

    respond_with(@courses)
  end

  def show
    @examinations = Examination.where(course_id: params[:id])

    respond_with(@course)
  end

  def new
    @course = Course.new

    authorize @course

    respond_with(@course)
  end

  def edit
    respond_with(@course)
  end

  def create
    @course = Course.new(course_params)

    authorize @course

    @course.save

    respond_with(@course)
  end

  def update
    @course.update(course_params)

    respond_with(@course)
  end

  def destroy
    @course.destroy.destroyed?

    respond_with(@course)
  end

  private

  def set_resource
    @course = Course.find(params[:id])

    authorize @course
  end

  def course_params
    params.require(:course).permit(:title, :description, teacher_profile_ids: [])
  end
end
