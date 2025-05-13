class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :person

  validates :data, presence: true

  has_paper_trail
end
