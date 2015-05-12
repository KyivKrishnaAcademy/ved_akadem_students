class Person < ActiveRecord::Base
  MARITAL_STATUSES = %i(single in_relationship married divorced widowed) #TODO use enums here since we run rails 4.1

  attr_accessor :skip_password_validation, :photo_upload_height, :photo_upload_width
  attr_accessor :crop_x, :crop_y, :crop_w, :crop_h
  attr_accessor :privacy_agreement

  devise :database_authenticatable, :registerable, :recoverable

  has_one :student_profile, dependent: :destroy
  has_one :teacher_profile, dependent: :destroy
  has_one :study_application, dependent: :destroy
  has_and_belongs_to_many :roles
  has_many :telephones, dependent: :destroy
  has_many :answers, dependent: :destroy
  has_many :questionnaire_completenesses, dependent: :destroy
  has_many :questionnaires, through: :questionnaire_completenesses
  has_many :administrated_groups, class_name: 'AcademicGroup', foreign_key: 'administrator_id'
  has_many :praeposted_groups, class_name: 'AcademicGroup', foreign_key: 'praepostor_id'
  has_many :curated_groups, class_name: 'AcademicGroup', foreign_key: 'curator_id'

  before_save :set_password, :set_complex_name

  accepts_nested_attributes_for :telephones, allow_destroy: true

  validates :email, format: { with: VALID_EMAIL_REGEX }, uniqueness: true
  validates :gender, inclusion: { in: [true, false] }
  validates :middle_name, :spiritual_name, length: { maximum: 50 }
  validates :name, :surname, length: { maximum: 50 }, presence: true
  validates :password, confirmation: true
  validates :password, length: { in: 6..128, unless: :skip_password_validation  }
  validates :privacy_agreement, acceptance: { accept: 'yes', unless: :skip_password_validation }, on: :create
  validates :telephones, :birthday, :education, :work, :marital_status, presence: true

  validate :check_photo_dimensions

  scope :by_complex_name, ->() { order("CASE WHEN (spiritual_name IS NULL OR spiritual_name = '') THEN (surname || name || middle_name) ELSE spiritual_name END") }

  mount_uploader :photo, PhotoUploader
  mount_uploader :passport, PassportUploader

  default_scope { where(deleted: false) }

  def crop_photo(params)
    assign_attributes(params)

    photo.recreate_versions!

    self.skip_password_validation = true

    save
  end

  def add_application_questionnaires
    questionnaires << study_application.program.questionnaires
      .where.not(id: questionnaire_ids) if study_application.present?
  end

  def remove_application_questionnaires(application)
    questionnaire_completenesses
      .where(completed: false, questionnaire_id: application.program.questionnaire_ids).destroy_all
  end

  def not_finished_questionnaires
    questionnaires.includes(:questionnaire_completenesses).where(questionnaire_completenesses: { completed: false })
  end

  def initial_answers
    answers
      .select('answers.*, questions.position')
      .joins(question: [questionnaire: [:questionnaire_completenesses]])
      .where(questionnaires: { kind: 'initial_questions' },
             questionnaire_completenesses: { completed: true, person_id: id })
      .distinct.order('questions.position')
  end

  def psycho_test_result
    psycho_tests = questionnaire_completenesses.joins(:questionnaire).where(questionnaires: { kind: 'psycho_test' })

    psycho_tests.first.result if psycho_tests.any?
  end

  def can_act?(*activities)
    activities.present? && roles.any? && (roles.pluck(:activities).flatten & activities.flatten).present?
  end

  def last_academic_group
    student_profile.academic_groups.where(group_participations: { leave_date: nil }).first if student_profile.present?
  end

  def pending_docs
    @pending_docs ||= count_pending_docs
  end

  private

  def count_pending_docs
    result = {}

    result[:questionnaires] = not_finished_questionnaires.count

    result.delete(:questionnaires) if result[:questionnaires].zero?

    [:photo, :passport].each do |person_field|
      result[person_field] = person_field if send(person_field).blank?
    end

    result
  end

  def set_password
    return unless encrypted_password.blank? && password.blank? && password_confirmation.blank?

    pswd                       = SecureRandom.hex(6)
    self.password              = pswd
    self.password_confirmation = pswd
  end

  def set_complex_name
    self.complex_name = if spiritual_name.present?
      "#{spiritual_name} (#{surname} #{name}#{middle_name.present? ? ' ' << middle_name : ''})"
    else
      "#{surname} #{name}#{middle_name.present? ? ' ' << middle_name : ''}"
    end
  end

  def check_photo_dimensions
    dimensions_present = photo_upload_height.present? && photo_upload_width.present?
    dimensions_invalid = photo_upload_width < 150 || photo_upload_height < 200 if dimensions_present

    errors.add(:photo, :size) if dimensions_invalid
  end
end
