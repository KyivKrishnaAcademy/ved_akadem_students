class PersonPolicy < ApplicationPolicy
  def show?
    super || owned?
  end

  def show_photo?
    show?
  end

  def crop_image?
    owned? || super
  end

  private

  def owned?
    record.id == user.id
  end
end
