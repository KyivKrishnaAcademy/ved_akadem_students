class PersonPolicy < ApplicationPolicy
  def show?
    super || owned?
  end

  private

  def owned?
    record.id == user.id
  end
end
