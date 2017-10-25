class ExaminationResultPolicy < BasePolicy
  def ui_manage?
    ui_create? && ui_update? && ui_destroy?
  end
end
