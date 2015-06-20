class PersonClassSchedulesLoadingInteraction < BaseInteraction
  include ClassSchedulesLoadable

  def init
    #TODO replace this when ElasticSearch appears
    #injection is possible!
    @class_schedules = ClassSchedule.personal_schedule(user, params[:page])
  end
end
