module Ui
  class PersonClassSchedulesLoadingInteraction < BaseInteraction
    include ClassSchedulesLoadable

    def init
      # TODO: replace this when ElasticSearch appears
      # TODO: injection is possible!
      @class_schedules = ClassScheduleWithPeople.personal_schedule_by_direction(
        user.id,
        params[:page],
        params[:direction]
      )
    end

    def pundit_user
      user
    end
  end
end
