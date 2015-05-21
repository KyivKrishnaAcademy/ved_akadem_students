class ClassSchedulesController < HtmlResponsableController
  include Crudable

  def index
    @class_schedules = ClassSchedule.all

    authorize ClassSchedule

    respond_with(@class_schedules)
  end

  def show
    respond_with(@class_schedule)
  end

  def new
    @class_schedule = ClassSchedule.new

    authorize @class_schedule

    respond_with(@class_schedule)
  end

  def edit
    respond_with(@class_schedule)
  end

  def create
    @class_schedule = ClassSchedule.new(class_schedule_params)

    authorize @class_schedule

    @class_schedule.save

    respond_with(@class_schedule)
  end

  def update
    @class_schedule.update(class_schedule_params)

    respond_with(@class_schedule)
  end

  def destroy
    @class_schedule.destroy.destroyed?

    respond_with(@class_schedule)
  end

  private

  def set_resource
    @class_schedule = ClassSchedule.find(params[:id])

    authorize @class_schedule
  end

  def class_schedule_params
    params.require(:class_schedule).permit(:course_id, :teacher_profile_id, :classroom_id, academic_group_ids: [])
  end
end
