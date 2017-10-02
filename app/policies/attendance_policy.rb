class AttendancePolicy < BasePolicy
  def ui_index?
    user.present?
  end
end
