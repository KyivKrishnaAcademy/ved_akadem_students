class ClassSchedule < ApplicationRecord
  include ClassScheduleCustomValidations

  belongs_to :classroom
  belongs_to :course
  belongs_to :teacher_profile

  has_many :academic_group_schedules, dependent: :destroy
  has_many :academic_groups, through: :academic_group_schedules

  has_many :attendances, dependent: :destroy

  validates :course, :classroom, :start_time, :finish_time, presence: true

  has_paper_trail

  def self.by_group(id, page = nil)
    joins(:academic_group_schedules)
      .where('finish_time > now()')
      .where(academic_group_schedules: { academic_group_id: id })
      .order(:start_time)
      .page(page)
      .per(25)
  end

  def real_class_schedule
    self
  end
end
