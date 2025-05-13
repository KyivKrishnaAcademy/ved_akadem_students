class QuestionnaireCompleteness < ApplicationRecord
  attribute :result, :json, default: {}

  belongs_to :person
  belongs_to :questionnaire

  has_paper_trail
end
