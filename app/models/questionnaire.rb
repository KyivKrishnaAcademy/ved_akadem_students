class Questionnaire < ActiveRecord::Base
  has_many :questions, dependent: :destroy
  has_and_belongs_to_many :study_applications
end
