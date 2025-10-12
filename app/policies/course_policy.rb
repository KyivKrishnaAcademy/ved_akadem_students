class CoursePolicy < BasePolicy
  def ui_index?
    user.can_act?(
      %w[
        academic_group:edit
        academic_group:new
        class_schedule:edit
        class_schedule:new
      ]
    )
  end

  def show?
    user.role_activity?('course:show')
  end
end
