class AttendancePolicy < BasePolicy
  def ui_index?
    user.present?
  end

  def ui_manage?
    ui_create? && ui_update? && ui_destroy?
  end
end
