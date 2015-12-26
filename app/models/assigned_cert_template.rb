class AssignedCertTemplate < ActiveRecord::Base
  belongs_to :academic_group
  belongs_to :certificate_template

  has_many :certificates

  before_save :set_cert_id_prefix

  validates :academic_group, :certificate_template, presence: true
  validates :academic_group_id, uniqueness: { scope: :certificate_template_id }
  validates :certificate_template_id, uniqueness: { scope: :academic_group_id }

  private

  def set_cert_id_prefix
    return self.cert_id_prefix = '' if academic_group.blank? || certificate_template.blank?

    if cert_id_prefix.blank?
      self.cert_id_prefix = "#{academic_group.title}-#{certificate_template_id}-"
    else
      true
    end
  end
end
