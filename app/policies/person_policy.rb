class PersonPolicy < ApplicationPolicy
  def show?
    super || owned?
  end

  def show_photo?
    show?
  end

  def show_passport?
    owned? || super
  end

  def crop_image?
    owned? || super
  end

  def update_image?
    crop_image?
  end

  private

  def owned?
    record.id == user.id
  end
end
