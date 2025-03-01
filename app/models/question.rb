class Question < ApplicationRecord
  serialize :data, coder: Hash

  belongs_to :questionnaire
  has_many :answers, dependent: :destroy

  accepts_nested_attributes_for :answers

  has_paper_trail
end
