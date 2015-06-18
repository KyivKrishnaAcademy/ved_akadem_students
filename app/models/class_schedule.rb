class ClassSchedule < ActiveRecord::Base
  include ClassScheduleCustomValidations

  belongs_to :classroom
  belongs_to :course
  belongs_to :teacher_profile

  has_many :academic_group_schedules, dependent: :destroy
  has_many :academic_groups, through: :academic_group_schedules

  has_many :attendances, dependent: :destroy

  validates :course, :classroom, :start_time, :finish_time, presence: true
end
