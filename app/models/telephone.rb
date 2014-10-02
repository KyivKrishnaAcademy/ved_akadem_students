class Telephone < ActiveRecord::Base
  VALID_PHONE_REGEX = /\(\d{2,3}\)\s\d{3}-\d{2}-\d{2}\z/

  belongs_to :person

  validates :phone, format: { with: VALID_PHONE_REGEX }
end
