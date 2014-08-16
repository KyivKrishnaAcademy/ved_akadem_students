class Person < ActiveRecord::Base
  attr_accessor :skip_password_validation, :photo_upload_height, :photo_upload_width
  attr_accessor :crop_x, :crop_y, :crop_w, :crop_h, :crop_done

  devise :database_authenticatable, :registerable, :recoverable

  has_one :student_profile, dependent: :destroy
  has_and_belongs_to_many :roles

  before_save :normalize_strings, :set_password

  after_update :crop_photo

  validates :password, length: { in: 6..128, unless: :skip_password_validation  }
  validates :password, confirmation: true
  validates :name,    length: { maximum: 50 }, presence: true
  validates :surname, length: { maximum: 50 }, presence: true
  validates :middle_name,     length: { maximum: 50 }
  validates :spiritual_name,  length: { maximum: 50 }
  validates :gender,          inclusion: { in: [true, false] }
  validates :telephone, presence: true, numericality: { less_than: 1_000_000_000_000, greater_than: 99_999_999_999 }
  validates :email, format: { with: VALID_EMAIL_REGEX }, uniqueness: true

  validate :check_photo_dimensions

  mount_uploader :photo, PhotoUploader

  private

  def crop_photo
    if crop_x.present? && !crop_done
      photo.recreate_versions!

      self.crop_done = true
      self.skip_password_validation = true
      self.save!
    end
  end

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
    if photo_upload_height.present? && photo_upload_width.present?
      ::Rails.logger.info "Photo upload dimensions: #{self.photo_upload_width}x#{self.photo_upload_height}"

      errors.add :photo, 'Dimensions of uploaded photo should be not less than 150x200 pixels.' if photo_upload_width < 150 || photo_upload_height < 200
    end
  end
end
