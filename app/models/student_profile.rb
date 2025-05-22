class StudentProfile < ApplicationRecord
  belongs_to :person
  has_many :group_participations, dependent: :destroy
  has_many :academic_groups, through: :group_participations
  has_many :attendances, dependent: :destroy
  has_many :class_schedules, through: :attendances
  has_many :certificates, dependent: :destroy
  has_many :examination_results, dependent: :destroy

  has_paper_trail

  after_create :assign_course_view_role

  def active?
    group_participations.where(leave_date: nil).limit(1).present?
  end

  def move_to_group(academic_group)
    academic_groups << academic_group
  end

  private

  def assign_course_view_role
    person.add_role_activity('course:show') if person.respond_to?(:add_role_activity)
  end
end
