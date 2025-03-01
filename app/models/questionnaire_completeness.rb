class QuestionnaireCompleteness < ApplicationRecord
  serialize :result, coder: Hash

  belongs_to :person
  belongs_to :questionnaire

  has_paper_trail
end
