class AcademicGroupSchedule < ActiveRecord::Base
  belongs_to :academic_group
  belongs_to :class_schedule

  validates :academic_group_id, uniqueness: { scope: :class_schedule_id }
  validates :class_schedule_id, uniqueness: { scope: :academic_group_id }
end
