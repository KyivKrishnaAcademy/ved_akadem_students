class PersonPolicy < ApplicationPolicy
  class Scope < Struct.new(:user, :scope)
    def resolve
      scope.all
    end
  end

  def show?
    super || owned?
  end

  def show_photo?
    show?
  end

  private

  def owned?
    record.id == user.id
  end
end
