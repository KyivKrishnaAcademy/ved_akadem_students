class Person < ActiveRecord::Base
  has_one :student_profile, dependent: :destroy

  before_save do |p|
    p.email          =          email.to_s.downcase
    p.name           =           name.to_s.downcase.titleize
    p.middle_name    =    middle_name.to_s.downcase.titleize
    p.surname        =        surname.to_s.downcase.titleize
    p.spiritual_name = spiritual_name.to_s.downcase.titleize
  end

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
