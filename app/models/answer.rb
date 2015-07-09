class Answer < ActiveRecord::Base
  belongs_to :question
  belongs_to :person

  validates :data, :question, :person, presence: true

  has_paper_trail
end
