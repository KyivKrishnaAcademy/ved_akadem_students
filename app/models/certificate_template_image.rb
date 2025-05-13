class CertificateTemplateImage < ApplicationRecord
  belongs_to :certificate_template
  belongs_to :signature

  validates :angle,
            :scale,
            :x,
            :y,
            presence: true

  has_paper_trail
end
