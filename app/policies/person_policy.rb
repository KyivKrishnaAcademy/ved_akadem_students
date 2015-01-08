class PersonPolicy < ApplicationPolicy
  def show_photo?
    owned? || show?
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
