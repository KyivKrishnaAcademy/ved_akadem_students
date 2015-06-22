class ClassSchedule < ActiveRecord::Base
  include ClassScheduleCustomValidations

  belongs_to :classroom
  belongs_to :course
  belongs_to :teacher_profile

  has_many :academic_group_schedules, dependent: :destroy
  has_many :academic_groups, through: :academic_group_schedules

  has_many :attendances, dependent: :destroy

  validates :course, :classroom, :start_time, :finish_time, presence: true

  def self.personal_schedule(person, page = nil)
    #TODO move to Postgres view

    student_or_teacher = if person.student_profile.present? && person.student_profile.academic_groups.ids.present?
                           { query: '(group_participations.student_profile_id = :student_profile_id AND '\
                                    'group_participations.leave_date IS NULL AND academic_groups.graduated_at IS NULL)',
                             params: { student_profile_id: person.student_profile.id } }
                         else
                           {}
                         end

    if person.teacher_profile.present?
      student_or_teacher[:query] = student_or_teacher[:query].present? ? "#{student_or_teacher[:query]} OR " : ''

      student_or_teacher[:query] << '(class_schedules.teacher_profile_id = :teacher_profile_id)'

      student_or_teacher[:params] = (student_or_teacher[:params] || {}).merge({ teacher_profile_id: person.teacher_profile.id })
    elsif student_or_teacher.blank?
      return ClassSchedule.none.page(nil)
    end

    ClassSchedule.joins('LEFT OUTER JOIN academic_group_schedules '\
                        'ON academic_group_schedules.class_schedule_id = class_schedules.id '\
                        'LEFT OUTER JOIN academic_groups '\
                        'ON academic_groups.id = academic_group_schedules.academic_group_id '\
                        'LEFT OUTER JOIN group_participations '\
                        'ON group_participations.academic_group_id = academic_groups.id')
                 .where('finish_time > now()')
                 .where(student_or_teacher[:query], student_or_teacher[:params])
                 .order(:start_time, :finish_time)
                 .select('DISTINCT ON (class_schedules.id) class_schedules.*')
                 .page(page)
                 .per(10)
  end
end
