module Ui
  class ScheduleAttendancesController < Ui::BaseController
    skip_before_action :verify_authenticity_token

    before_action :set_resource, only: %i[update destroy]

    def index
      authorize Attendance, :ui_index?

      respond_with_interaction Ui::ScheduleAttendancesLoadingInteraction
    end

    def create
      attendance = Attendance.new(create_params)

      authorize attendance, :ui_create?

      respond_with_interaction Ui::AttendanceUpdatingInteraction, attendance
    end

    def update
      @attendance.assign_attributes(update_params)
      @attendance.revision += 1

      authorize @attendance, :ui_update?

      respond_with_interaction Ui::AttendanceUpdatingInteraction, @attendance
    end

    def destroy
      authorize @attendance, :ui_destroy?

      respond_with_interaction Ui::AttendanceDestroyingInteraction, @attendance
    end

    private

    def create_params
      params.permit(:presence, :class_schedule_id, :student_profile_id)
    end

    def update_params
      params.permit(:presence)
    end

    def set_resource
      @attendance = Attendance.find_by!(id: params[:id], revision: params[:revision])
    end
  end
end
