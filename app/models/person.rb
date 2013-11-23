class Person < ActiveRecord::Base
  has_one :student_profile, dependent: :destroy

  validates :name,    length: { maximum: 50 }, presence: true 
  validates :surname, length: { maximum: 50 }, presence: true 
  validates :gender,          presence: true
  validates :middle_name,     length: { maximum: 50 }
  validates :spiritual_name,  length: { maximum: 50 }
  validates :telephone, 
    presence: true, uniqueness: true,
    numericality: { less_than: 1_000_000_000_000, greater_than: 99_999_999_999 }
  
  VALID_EMAIL_REGEX = /(\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z)|(\A\s*\z)/i
  validates :email, format: { with: VALID_EMAIL_REGEX }
end
