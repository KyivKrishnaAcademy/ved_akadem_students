class PersonPolicy < ApplicationPolicy
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
