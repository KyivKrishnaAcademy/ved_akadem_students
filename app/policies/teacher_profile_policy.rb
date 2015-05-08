class TeacherProfilePolicy < ApplicationPolicy
  def index?
    user.can_act?(%w(course:edit course:new))
  end
end
