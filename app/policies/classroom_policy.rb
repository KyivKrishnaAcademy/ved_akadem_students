class ClassroomPolicy < BasePolicy
  def ui_index?
    user.can_act?(%w[class_schedule:edit class_schedule:new])
  end
end
