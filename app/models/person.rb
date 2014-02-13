class Person < ActiveRecord::Base

  devise :database_authenticatable

  has_one :student_profile, dependent: :destroy
  has_and_belongs_to_many :roles

  before_save do |p|
    p.email          = email.to_s.downcase
    p.name           = downcase_titleize name
    p.middle_name    = downcase_titleize middle_name
    p.surname        = downcase_titleize surname
    p.spiritual_name = downcase_titleize spiritual_name
    p.encrypted_password = SecureRandom.urlsafe_base64 if p.password.blank?
  end

  before_validation do |p|
    if p.username.blank?
      p.username = (p.email.blank? ? p.telephone : p.email).to_s.downcase
    end
  end

  validates :password, confirmation: true
  validates :name,    length: { maximum: 50 }, presence: true
  validates :surname, length: { maximum: 50 }, presence: true
  validates :middle_name,     length: { maximum: 50 }
  validates :spiritual_name,  length: { maximum: 50 }
  validates :gender,          inclusion: { in: [true, false] }
  validates :username,  presence: true, uniqueness: true
  validates :telephone, presence: true, uniqueness: true,
    numericality: { less_than: 1_000_000_000_000, greater_than: 99_999_999_999 }

  VALID_EMAIL_REGEX = /(\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z)|(\A\s*\z)/i # allows field to be empty
  validates :email, format: { with: VALID_EMAIL_REGEX }

  private

  def downcase_titleize(str)
    str.to_s.mb_chars.downcase.titleize.to_s
  end
end
