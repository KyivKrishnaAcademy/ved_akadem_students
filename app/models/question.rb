class Question < ApplicationRecord
  store :data, coder: JSON

  belongs_to :questionnaire
  has_many :answers, dependent: :destroy

  accepts_nested_attributes_for :answers

  has_paper_trail
end
