class Signature < ApplicationRecord
  validates :name, :file, presence: true

  mount_uploader :file, SignatureUploader

  has_paper_trail
end
