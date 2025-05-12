class CertificateTemplate < ApplicationRecord
  validates :title, presence: true
  attribute :is_final_score_required, :boolean, default: false

  has_many :certificate_template_entries, dependent: :destroy
  has_many :certificate_template_images, dependent: :destroy
  has_many :certificates, dependent: :restrict_with_exception

  belongs_to :institution

  enum program_type: { other: 0, bhakti_school: 1, bhakti_sastri: 2, disciple: 3, real_husband: 4 }

  accepts_nested_attributes_for :certificate_template_entries, allow_destroy: true
  accepts_nested_attributes_for :certificate_template_images, allow_destroy: true

  validates :institution, :program_type, presence: true

  mount_uploader :file, PDFUploader

  has_paper_trail
end
