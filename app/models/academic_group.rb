class AcademicGroup < ActiveRecord::Base
  VALID_TITLE_REGEX = /\A(з|)[а-я]{2}\d{2}-\d\z/i

  has_many :group_participations, dependent: :destroy
  has_many :student_profiles, through: :group_participations

  has_many :academic_group_schedules, dependent: :destroy
  has_many :class_schedules, through: :academic_group_schedules

  belongs_to :administrator, class_name: 'Person'
  belongs_to :praepostor, class_name: 'Person'
  belongs_to :curator, class_name: 'Person'

  before_save do |p|
    p.title = title.mb_chars.upcase.to_s
  end

  validates :title, format: { with: VALID_TITLE_REGEX }
  validates :title, presence: true, uniqueness: true

  def active_students
    leave_date = if active?
                   { query: 'group_participations.leave_date IS ?',
                     value: nil }
                 else
                   { query: 'group_participations.leave_date >= ? OR group_participations.leave_date IS NULL',
                     value: graduated_at }
                 end

    Person.joins(student_profile: [group_participations: [:academic_group]])
      .where(academic_groups: { id: id })
      .where(leave_date[:query], leave_date[:value])
      .order(:complex_name)
      .distinct
  end

  def active?
    !graduated_at
  end
end
