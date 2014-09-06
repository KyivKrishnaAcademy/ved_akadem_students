class Person < ActiveRecord::Base
  attr_accessor :skip_password_validation, :photo_upload_height, :photo_upload_width
  attr_accessor :crop_x, :crop_y, :crop_w, :crop_h

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

  validates :password, length: { in: 6..128, unless: :skip_password_validation  }
  validates :password, confirmation: true
  validates :name,    length: { maximum: 50 }, presence: true
  validates :surname, length: { maximum: 50 }, presence: true
  validates :middle_name,     length: { maximum: 50 }
  validates :spiritual_name,  length: { maximum: 50 }
  validates :gender,          inclusion: { in: [true, false] }
  validates :telephones, presence: true
  validates :email, format: { with: VALID_EMAIL_REGEX }, uniqueness: true

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
    questionnaires << study_application.program.questionnaires if study_application.present?
  end

  def remove_application_questionnaires(application)
    questionnaire_completenesses.where(completed: false, questionnaire_id: application.program.questionnaire_ids).destroy_all
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
    dimensions_valid   = photo_upload_width < 150 || photo_upload_height < 200 if dimensions_present

    if dimensions_present && dimensions_valid
      errors.add :photo, 'Dimensions of uploaded photo should be not less than 150x200 pixels.'
    end
  end
end
