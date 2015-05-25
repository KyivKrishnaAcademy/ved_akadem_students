class StudentProfile < ActiveRecord::Base
  belongs_to :person
  has_many :group_participations, dependent: :destroy
  has_many :academic_groups, through: :group_participations
  has_many :attendances, dependent: :destroy
  has_many :class_schedules, through: :attendances

  def move_to_group(academic_group)
    remove_from_groups

    academic_groups << academic_group
  end

  def remove_from_groups
    prev = group_participations.where(leave_date: nil)

    prev.each(&:leave!) if prev.any?
  end
end
