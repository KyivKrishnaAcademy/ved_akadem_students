class Signature < ApplicationRecord
  validates :name, :file, presence: true

  has_many :certificate_template_images, dependent: :restrict_with_exception

  mount_uploader :file, SignatureUploader

  has_paper_trail
end
