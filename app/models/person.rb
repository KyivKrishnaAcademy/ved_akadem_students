class Person < ApplicationRecord
  # TODO: use enums here since we run rails 4.1
  MARITAL_STATUSES = %i[single in_relationship married divorced widowed].freeze

  class SymbolWrapper
    def self.load(string)
      string.try(:to_sym)
    end

    def self.dump(symbol)
      symbol.to_s
    end
  end

  serialize :locale, SymbolWrapper

  attr_accessor :skip_password_validation, :photo_upload_height, :photo_upload_width, :crop_x, :crop_y, :crop_w,
                :crop_h, :privacy_agreement

  devise :database_authenticatable, :registerable, :recoverable
  include DeviseTokenAuth::Concerns::User

  has_one :student_profile, dependent: :destroy
  has_one :teacher_profile, dependent: :destroy
  has_one :study_application, dependent: :destroy
  has_and_belongs_to_many :roles
  has_many :telephones, dependent: :destroy
  has_many :notes, dependent: :destroy
  has_many :answers, dependent: :destroy
  has_many :unsubscribes, dependent: :destroy
  has_many :questionnaire_completenesses, dependent: :destroy
  has_many :questionnaires, through: :questionnaire_completenesses

  has_many :administrated_groups,
           class_name: 'AcademicGroup',
           foreign_key: 'administrator_id',
           dependent: :nullify,
           inverse_of: 'administrator'
  has_many :praeposted_groups,
           class_name: 'AcademicGroup',
           foreign_key: 'praepostor_id',
           dependent: :nullify,
           inverse_of: 'praepostor'
  has_many :curated_groups,
           class_name: 'AcademicGroup',
           foreign_key: 'curator_id',
           dependent: :nullify,
           inverse_of: 'curator'

  before_save :set_password, :set_complex_name, :set_uid

  accepts_nested_attributes_for :telephones, allow_destroy: true

  validates :gender, inclusion: { in: [true, false] }
  validates :middle_name, :name, :surname, :diploma_name, length: { maximum: 50 }
  validates :name, :surname, presence: true
  validates :password, confirmation: true
  validates :password, length: { in: 6..128, unless: :skip_password_validation }, on: :create
  validates :password, length: { in: 6..128 }, allow_blank: true, on: :update
  validates :privacy_agreement, acceptance: { accept: 'yes', unless: :skip_password_validation }, on: :create
  validates :telephones, :birthday, :marital_status, presence: true

  validate :check_photo_dimensions
  validate :validate_age

  scope :with_application, ->(id) { joins(:study_application).where(study_applications: { program_id: id }) }

  mount_uploader :photo, PhotoUploader

  delegate :active?, to: :student_profile, prefix: :student, allow_nil: true

  has_paper_trail

  def self.by_complex_name
    order(
      <<-SQL.squish
        CASE
          WHEN (diploma_name IS NULL OR diploma_name = '')
          THEN (surname || name || middle_name)
          ELSE diploma_name
        END
      SQL
    )
  end

  def self.without_application
    joins('LEFT OUTER JOIN "study_applications" ON "study_applications"."person_id" = "people"."id"')
      .joins('LEFT OUTER JOIN "student_profiles" ON "student_profiles"."person_id" = "people"."id"')
      .joins('LEFT OUTER JOIN "teacher_profiles" ON "teacher_profiles"."person_id" = "people"."id"')
      .where(study_applications: { id: nil })
      .where(student_profiles: { id: nil })
      .where(teacher_profiles: { id: nil })
  end

  def self.search(query)
    query_array = query.strip.split(/\s+/).map { |term| "%#{term}%" }

    return all if query_array.none?

    where('complex_name ilike any ( array[?] )', query_array)
  end

  def crop_photo(params)
    assign_attributes(params)

    photo.recreate_versions!

    self.skip_password_validation = true

    save
  end

  def add_application_questionnaires
    return if study_application.blank?

    questionnaires << study_application
                        .program
                        .questionnaires
                        .where.not(id: questionnaire_ids)
  end

  def remove_application_questionnaires(application)
    questionnaire_completenesses
      .where(completed: false, questionnaire_id: application.program.questionnaire_ids).destroy_all
  end

  def not_finished_questionnaires
    questionnaires.includes(:questionnaire_completenesses).where(questionnaire_completenesses: { completed: false })
  end

  def psycho_test_result
    psycho_tests = questionnaire_completenesses.joins(:questionnaire).where(questionnaires: { kind: 'psycho_test' })

    psycho_tests.first.result if psycho_tests.any?
  end

  def can_act?(*activities)
    activities.present? && roles.any? && (roles.pluck(:activities).flatten & activities.flatten).present?
  end

  def last_academic_groups
    return AcademicGroup.none if student_profile.blank?

    student_profile
      .academic_groups
      .where(group_participations: { leave_date: nil })
      .order('group_participations.join_date ASC')
  end

  def previous_academic_groups
    return AcademicGroup.none if student_profile.blank?

    student_profile
      .academic_groups
      .where.not(group_participations: { leave_date: nil })
      .order('group_participations.join_date ASC')
  end

  def pending_docs
    @pending_docs ||= count_pending_docs
  end

  def short_name
    return diploma_name if diploma_name.present?

    "#{surname} #{name}"
  end

  def respectful_name
    return diploma_name if diploma_name.present?
    return name if middle_name.blank?

    "#{name} #{middle_name}"
  end

  private

  def count_pending_docs
    result = {}

    result[:questionnaires] = not_finished_questionnaires.count

    result.delete(:questionnaires) if result[:questionnaires].zero?

    result[:photo] = :photo if send(:photo).blank?

    result
  end

  def set_password
    return unless encrypted_password.blank? && password.blank? && password_confirmation.blank?

    pswd                       = SecureRandom.hex(6)
    self.password              = pswd
    self.password_confirmation = pswd
  end

  def set_complex_name
    civil_name = "#{surname} #{name}#{middle_name.present? ? ' ' << middle_name : ''}"

    self.complex_name = if diploma_name.present?
      if surname.present? && name.present?
        "#{diploma_name} (#{civil_name})"
      else
        diploma_name
      end
    else
      civil_name
    end
  end

  def check_photo_dimensions
    dimensions_present = photo_upload_height.present? && photo_upload_width.present?
    dimensions_invalid = photo_upload_width < 150 || photo_upload_height < 200 if dimensions_present

    errors.add(:photo, :size) if dimensions_invalid
  end

  def validate_age
    return if birthday.blank? || birthday < 16.years.ago.to_date

    errors.add(:birthday, :over_16_years_old)
  end

  def set_uid
    self.uid = email if uid.blank?
  end
end
