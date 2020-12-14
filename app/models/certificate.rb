class Certificate < ApplicationRecord
  has_one :academic_group
  has_one :certificate_template
  has_one :student_profile

  validates :serial_id, :issued_date, presence: true
end
