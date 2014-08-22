class Telephone < ActiveRecord::Base
  VALID_PHONE_REGEX = /\d{10,}\z/

  belongs_to :person

  validates :phone, format: { with: VALID_PHONE_REGEX }
end
