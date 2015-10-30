module Ui
  class GroupClassSchedulesLoadingInteraction < BaseInteraction
    include ClassSchedulesLoadable

    def init
      #TODO replace this when ElasticSearch appears
      #injection is possible!
      @class_schedules = ClassSchedule.by_group(params[:id], params[:page])
    end
  end
end
