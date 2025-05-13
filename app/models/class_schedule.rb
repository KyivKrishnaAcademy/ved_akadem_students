class ClassSchedule < ApplicationRecord
  include ClassScheduleCustomValidations

  belongs_to :classroom
  belongs_to :course, counter_cache: true
  belongs_to :teacher_profile

  has_many :academic_group_schedules, dependent: :destroy
  has_many :academic_groups, through: :academic_group_schedules

  has_many :attendances, dependent: :destroy

  validates :start_time, :finish_time, presence: true
  validates :classroom, presence: true
  validates :course, presence: true

  has_paper_trail

  def real_class_schedule
    self
  end

  class << self
    def by_group(id, page, direction)
      joins(:academic_group_schedules)
        .where(academic_group_schedules: { academic_group_id: id })
        .by_direction(direction)
        .page(page)
        .per(25)
    end

    def by_direction(direction)
      if direction == 'past'
        where('finish_time <= now()').order(start_time: :desc, finish_time: :desc)
      else
        where('finish_time > now()').order(:start_time, :finish_time)
      end
    end
  end
end
