class AssignedCertTemplate < ActiveRecord::Base
  belongs_to :academic_group
  belongs_to :certificate_template

  validates :academic_group, :certificate_template, presence: true
  validates :academic_group_id, uniqueness: { scope: :certificate_template_id }
  validates :certificate_template_id, uniqueness: { scope: :academic_group_id }
end
