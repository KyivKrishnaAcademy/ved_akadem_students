class Telephone < ApplicationRecord
  belongs_to :person

  before_validation :normalize

  validate :phone_format

  has_paper_trail

  private

  def phone_format
    return true if GlobalPhone.validate(phone)

    errors.add(:phone, I18n.t('activerecord.errors.models.telephone.invalid'))
  end

  def normalize
    self.phone = GlobalPhone.normalize(phone)
  end
end
