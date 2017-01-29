module Ui
  class ClassSchedulesLoadingInteraction < BaseInteraction
    include ClassSchedulesLoadable

    def init
      # TODO: replace this when ElasticSearch appears
      # TODO: injection is possible!
      @class_schedules = ClassSchedule.order(start_time: :desc, finish_time: :desc).page(params[:page]).per(25)
    end
  end
end
