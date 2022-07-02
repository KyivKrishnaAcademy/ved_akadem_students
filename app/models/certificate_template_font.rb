class CertificateTemplateFont < ApplicationRecord
  validates :name, :file, presence: true

  mount_uploader :file, TTFUploader
end
