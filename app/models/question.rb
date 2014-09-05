class Question < ActiveRecord::Base
  serialize :data, Hash

  belongs_to :questionnaire
  has_many :answers, dependent: :destroy
end
