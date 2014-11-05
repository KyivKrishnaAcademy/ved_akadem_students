class Person < ActiveRecord::Base
  MARITAL_STATUSES = %i[single in_relationship married divorced widowed]

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

  before_save :normalize_strings, :set_password

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

  mount_uploader :photo, PhotoUploader
  mount_uploader :passport, PassportUploader

  default_scope { where(deleted: false) }

  def crop_photo(params)
    assign_attributes(params)

    photo.recreate_versions!

    self.skip_password_validation = true
    self.save
  end

  def add_application_questionnaires
    questionnaires << study_application.program.questionnaires.where.not(id: questionnaire_ids) if study_application.present?
  end

  def remove_application_questionnaires(application)
    questionnaire_completenesses.where(completed: false, questionnaire_id: application.program.questionnaire_ids).destroy_all
  end

  def not_finished_questionnaires
    questionnaires.includes(:questionnaire_completenesses).where(questionnaire_completenesses: { completed: false })
  end

  def psycho_test_result
    psycho_tests = questionnaire_completenesses.joins(:questionnaire).where(questionnaires: { kind: 'psycho_test' })

    psycho_tests.first.result if psycho_tests.any?
  end

  def can_act?(*activities)
    if activities.present? && roles.any?
      (roles.pluck(:activities).flatten & activities.flatten).present?
    end
  end

  private

  def downcase_titleize(str)
    str.to_s.mb_chars.downcase.titleize.to_s
  end

  def normalize_strings
    self.name           = downcase_titleize(name)
    self.middle_name    = downcase_titleize(middle_name)
    self.surname        = downcase_titleize(surname)
    self.spiritual_name = downcase_titleize(spiritual_name)
  end

  def set_password
    if encrypted_password.blank? && password.blank? && password_confirmation.blank?
      pswd          = SecureRandom.hex(6)
      self.password = pswd
      self.password_confirmation = pswd
    end
  end

  def check_photo_dimensions
    dimensions_present = photo_upload_height.present? && photo_upload_width.present?
    dimensions_invalid = photo_upload_width < 150 || photo_upload_height < 200 if dimensions_present

    errors.add(:photo, :size) if dimensions_invalid
  end
end
