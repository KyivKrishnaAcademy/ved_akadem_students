class CertificateTemplateFont < ApplicationRecord
  validates :name, :file, presence: true

  has_many :certificate_template_entries, dependent: :restrict_with_exception

  mount_uploader :file, TTFUploader
end
