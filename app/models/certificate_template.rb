class CertificateTemplate < ApplicationRecord
  validates :title, presence: true

  has_many :certificate_template_entries, dependent: :destroy

  accepts_nested_attributes_for :certificate_template_entries, allow_destroy: true
end
