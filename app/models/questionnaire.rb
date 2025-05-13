class Questionnaire < ApplicationRecord
  include Ilikable

  serialize :rule, coder: JSON

  has_many :programs_questionnaires, dependent: :destroy, class_name: 'ProgramsQuestionnaire'
  has_many :questions, dependent: :destroy
  has_many :questionnaire_completenesses, dependent: :destroy
  has_many :programs, through: :programs_questionnaires
  has_many :people, through: :questionnaire_completenesses

  accepts_nested_attributes_for :questions

  validates :title_ru, :title_uk, presence: true

  has_paper_trail
end
