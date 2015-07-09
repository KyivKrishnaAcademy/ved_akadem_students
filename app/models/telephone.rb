class Telephone < ActiveRecord::Base
  VALID_PHONE_REGEX = /\A\+([\s\-]*\d){8,}\z/

  belongs_to :person

  validates :phone, format: { with: VALID_PHONE_REGEX }

  has_paper_trail
end
