class ClassSchedule < ActiveRecord::Base
  belongs_to :classroom
  belongs_to :course
  belongs_to :teacher_profile

  has_many :academic_group_schedules, dependent: :destroy
  has_many :academic_groups, through: :academic_group_schedules

  has_many :attendances, dependent: :destroy

  validates :course, :classroom, :start_time, :finish_time, presence: true

  validate :enough_roominess, :duration, :teacher_availability, :classroom_availability, :academic_groups_availability

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

  def duration
    return if finish_time.blank? || start_time.blank?
    return if finish_time - start_time < 1.day && finish_time - start_time >= 10.minutes && start_time < finish_time

    errors.add(:start_time, I18n.t('activerecord.errors.models.class_schedule.wrong_times'))
    errors.add(:finish_time, I18n.t('activerecord.errors.models.class_schedule.wrong_times'))
  end

  def teacher_availability
    return if teacher_profile.blank?
    return if obj_availability(teacher_profile_id: teacher_profile.id)

    errors.add(:teacher_profile,
               I18n.t('activerecord.errors.models.class_schedule.attributes.teacher_profile.availability'))
  end

  def classroom_availability
    return if classroom.blank?
    return if obj_availability(classroom_id: classroom.id)

    errors.add(:classroom, I18n.t('activerecord.errors.models.class_schedule.attributes.classroom.availability'))
  end

  def academic_groups_availability
    return if academic_groups.none?

    unavailable_groups = AcademicGroup.joins(:class_schedules)
                                      .where(academic_group_schedules: { academic_group_id: academic_groups.map(&:id) })
                                      .where('(class_schedules.start_time, class_schedules.finish_time) '\
                                               'OVERLAPS (:start, :finish)',
                                             { start: start_time, finish: finish_time })
                                      .distinct

    return if unavailable_groups.none?

    errors.add(:academic_groups,
               I18n.t('activerecord.errors.models.class_schedule.attributes.academic_groups.availability',
                      groups: unavailable_groups.pluck(:title).sort.join(', ')))
  end

  def obj_availability(params)
    ClassSchedule.where(params)
                 .where('(start_time, finish_time) OVERLAPS (:start, :finish)',
                        { start: start_time, finish: finish_time })
                 .first
                 .blank?
  end
end
