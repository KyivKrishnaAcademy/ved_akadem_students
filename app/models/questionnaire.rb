class Questionnaire < ActiveRecord::Base
  has_many :questions, dependent: :destroy
  has_and_belongs_to_many :programs

  validates :title, presence: true
end
