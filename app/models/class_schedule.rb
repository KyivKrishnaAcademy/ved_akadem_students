class ClassSchedule < ActiveRecord::Base
  belongs_to :classroom
  belongs_to :course
  belongs_to :teacher_profile

  has_many :academic_group_schedules, dependent: :destroy
  has_many :academic_groups, through: :academic_group_schedules

  has_many :attendances, dependent: :destroy

  validates :course, :classroom, :start_time, :finish_time, presence: true

  validate :enough_roominess

  private

  def enough_roominess
    return if classroom.blank? || academic_groups.none?

    required_roominess = academic_groups.map { |ag| ag.active_students.count }.inject(:+)

    return if required_roominess <= classroom.roominess

    errors.add(:classroom,
               I18n.t('activerecord.errors.models.class_schedule.attributes.classroom.roominess',
                      actual: classroom.roominess,
                      required: required_roominess))
  end
end
