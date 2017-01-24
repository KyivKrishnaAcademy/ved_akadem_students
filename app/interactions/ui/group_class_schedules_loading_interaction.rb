module Ui
  class GroupClassSchedulesLoadingInteraction < BaseInteraction
    include ClassSchedulesLoadable

    def init
      # TODO: replace this when ElasticSearch appears
      @class_schedules = ClassSchedule.by_group(params[:id], params[:page], params[:direction])
      # TODO: injection is possible!
    end
  end
end
