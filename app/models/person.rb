class Person < ActiveRecord::Base
  has_one :student_profile, dependent: :destroy

  before_save do |p|
    p.email          = email.to_s.downcase
    p.name           = downcase_titleize name
    p.middle_name    = downcase_titleize middle_name
    p.surname        = downcase_titleize surname
    p.spiritual_name = downcase_titleize spiritual_name
  end

  validates :name,    length: { maximum: 50 }, presence: true 
  validates :surname, length: { maximum: 50 }, presence: true 
  validates :middle_name,     length: { maximum: 50 }
  validates :spiritual_name,  length: { maximum: 50 }
  validates :gender,          inclusion: { in: [true, false] }
  validates :telephone, 
    presence: true, uniqueness: true,
    numericality: { less_than: 1_000_000_000_000, greater_than: 99_999_999_999 }
  
  VALID_EMAIL_REGEX = /(\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z)|(\A\s*\z)/i
  validates :email, format: { with: VALID_EMAIL_REGEX }

  private

  def downcase_titleize(str)
    str.to_s.mb_chars.downcase.titleize.to_s
  end
end
