class AcademicGroup < ActiveRecord::Base
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

  VALID_EMAIL_REGEX = /\A(з|)[а-я]{2}\d{2}-\d\z/i
  validates :title, format: { with: VALID_EMAIL_REGEX }
  validates :title, presence: true, uniqueness: true

  def active_students
    Person.joins(student_profile: [group_participations: [:academic_group]])
      .where(group_participations: { leave_date: nil },
             academic_groups: { id: id })
      .order(:complex_name)
      .distinct
  end
end
