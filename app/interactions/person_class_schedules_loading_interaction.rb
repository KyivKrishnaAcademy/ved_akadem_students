class PersonClassSchedulesLoadingInteraction < BaseInteraction
  def init
    #TODO replace this when ElasticSearch appears
    #injection is possible!
    @class_schedules = ClassSchedule.all.page(params[:page]).per(10)
  end

  def as_json
    {
      class_schedules: []
    }
  end
end
