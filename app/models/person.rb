class Person < ActiveRecord::Base

  devise :database_authenticatable

  has_one :student_profile, dependent: :destroy
  has_and_belongs_to_many :roles

  before_save :normalize_strings

  validates :password, confirmation: true, presence: true
  validates :name,    length: { maximum: 50 }, presence: true
  validates :surname, length: { maximum: 50 }, presence: true
  validates :middle_name,     length: { maximum: 50 }
  validates :spiritual_name,  length: { maximum: 50 }
  validates :gender,          inclusion: { in: [true, false] }
  validates :telephone, presence: true, uniqueness: true,
    numericality: { less_than: 1_000_000_000_000, greater_than: 99_999_999_999 }

  VALID_EMAIL_REGEX = /(\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z)/i
  validates :email, format: { with: VALID_EMAIL_REGEX }

  private

  def downcase_titleize(str)
    str.to_s.mb_chars.downcase.titleize.to_s
  end

  def normalize_strings
    self.email          = email.to_s.downcase
    self.name           = downcase_titleize(name)
    self.middle_name    = downcase_titleize(middle_name)
    self.surname        = downcase_titleize(surname)
    self.spiritual_name = downcase_titleize(spiritual_name)
  end
end
