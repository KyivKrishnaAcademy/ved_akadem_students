class CertificateTemplate < ApplicationRecord
  validates :title, presence: true

  has_many :certificate_template_entries, dependent: :destroy
  has_many :certificates, dependent: :restrict_with_exception

  accepts_nested_attributes_for :certificate_template_entries, allow_destroy: true

  mount_uploader :file, PDFUploader
end
