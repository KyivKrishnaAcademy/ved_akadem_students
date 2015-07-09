class Questionnaire < ActiveRecord::Base
  serialize :rule, Hash

  has_and_belongs_to_many :programs
  has_many :questions, dependent: :destroy
  has_many :questionnaire_completenesses, dependent: :destroy
  has_many :people, through: :questionnaire_completenesses

  accepts_nested_attributes_for :questions

  validates :title_ru, :title_uk, presence: true

  has_paper_trail
end
