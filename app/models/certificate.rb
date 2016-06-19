class Certificate < ActiveRecord::Base
  belongs_to :assigned_cert_template
  belongs_to :student_profile

  before_save :set_cert_id

  validates :assigned_cert_template, :student_profile, presence: true
  validates :assigned_cert_template_id, uniqueness: { scope: :student_profile_id }
  validates :student_profile_id, uniqueness: { scope: :assigned_cert_template_id }

  private

  def set_cert_id
    return true if cert_id.present? || assigned_cert_template.blank? || student_profile.blank?

    self.cert_id = "#{assigned_cert_template.cert_id_prefix}#{student_profile.person_id}"
  end
end
