module Ui
  class ScheduleAttendancesController < Ui::BaseController
    before_action :set_resource, only: [:update, :destroy]

    def index
      authorize Attendance, :ui_index?

      respond_with_interaction Ui::ScheduleAttendancesLoadingInteraction
    end

    def create
      attendance = Attendance.new(create_params)

      respond_with_interaction Ui::AttendanceUpdatingInteraction, attendance
    end

    def update
      @attendance.assign_attributes(update_params)

      respond_with_interaction Ui::AttendanceUpdatingInteraction, @attendance
    end

    def destroy
      respond_with_interaction Ui::AttendanceDestroyingInteraction, @attendance
    end

    private

    def respond_with_interaction(klass, resource = nil)
      interaction = klass.new(user: current_person, params: params, resource: resource)

      render json: interaction, status: interaction.status
    end

    def create_params
      params.permit(:presence, :class_schedule_id, :student_profile_id)
    end

    def update_params
      params.permit(:presence)
    end

    def set_resource
      @attendance = Attendance.find(params[:id])
    end
  end
end
