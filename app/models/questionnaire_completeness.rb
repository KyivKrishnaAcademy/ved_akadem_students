class QuestionnaireCompleteness < ActiveRecord::Base
  belongs_to :person
  belongs_to :questionnaire
end
