class ClassSchedulesController < HtmlRespondableController
  include Crudable
  include ClassSchedulesRefreshable

  after_action :refresh_class_schedules_mv, only: %i(create destroy update)

  def index
    @class_schedules = ClassSchedule.order(:start_time)

    authorize ClassSchedule

    respond_with(@class_schedules)
  end

  def new
    @class_schedule = ClassSchedule.new(params_for_new)

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

    location = if params[:commit] == t('class_schedules.create_and_clone')
      new_class_schedule_path(class_schedule: class_schedule_params)
    else
      class_schedules_path
    end

    # TODO: check the location on failure
    respond_with(@class_schedule, location: location)
  end

  def update
    @class_schedule.update(class_schedule_params)
    # TODO: check the location on failure
    respond_with(@class_schedule, location: class_schedules_path)
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
    params.require(:class_schedule).permit(:classroom_id, :course_id, :finish_time, :start_time, :subject,
                                           :teacher_profile_id, academic_group_ids: [])
  end

  def params_for_new
    if params[:class_schedule].present?
      class_schedule_params.merge(start_time: offset_time(:start_time, 1.week),
                                  finish_time: offset_time(:finish_time, 1.week))
    else
      {}
    end
  end

  def offset_time(param, value)
    Time.zone.parse(params[:class_schedule][param]) + value
  end
end
