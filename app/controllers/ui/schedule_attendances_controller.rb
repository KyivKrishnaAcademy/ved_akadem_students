module Ui
  class ScheduleAttendancesController < Ui::BaseController
    def index
      authorize Attendance, :ui_index?

      respond_with_interaction Ui::ScheduleAttendancesLoadingInteraction
    end
  end
end
