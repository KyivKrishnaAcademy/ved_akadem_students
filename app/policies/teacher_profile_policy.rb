class TeacherProfilePolicy < BasePolicy
  def ui_index?
    user.can_act?(%w[course:edit course:new class_schedule:edit class_schedule:new])
  end
end
