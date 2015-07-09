class QuestionnaireCompleteness < ActiveRecord::Base
  serialize :result, Hash

  belongs_to :person
  belongs_to :questionnaire

  has_paper_trail
end
