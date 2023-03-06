class CoursesController < HtmlRespondableController
  include Crudable
  include ClassSchedulesRefreshable

  after_action :refresh_class_schedules_mv, only: %i[destroy update]

  def index
    @courses = Course.order(:title)

    authorize Course

    respond_with(@courses)
  end

  def show
    @examinations = Examination.where(course_id: params[:id]).order(:title)
    @academic_groups = @course.academic_groups.order(:title)
    @class_schedules_count = @course.class_schedules_count

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
    errors = []

    if @course.class_schedules_count.positive?
      errors << t(
        'courses.destroy.remove_class_schedules_first',
        class_schedules_count: @course.class_schedules_count
      )
    end

    if @course.examination_results_count.positive?
      errors << t(
        'courses.destroy.remove_examination_results_first',
        examination_results_count: @course.examination_results_count
      )
    end

    if errors.any?
      joined_errors = "#{t('courses.destroy.unable_to_destroy')} #{errors.join(', ')}"

      redirect_back(
        fallback_location: courses_path,
        flash: {
          danger: joined_errors
        }
      )
    else
      @course.destroy

      respond_with(@course)
    end
  end

  private

  def set_resource
    @course = Course.find(params[:id])

    authorize @course
  end

  def course_params
    params.require(:course).permit(:title, :variant, :description, teacher_profile_ids: [])
  end
end
