class Question < ActiveRecord::Base
  serialize :data, Hash

  belongs_to :questionnaire
  has_many :answers, dependent: :destroy

  accepts_nested_attributes_for :answers

  def answer_by_person(person)
    answers.find_or_initialize_by(person: person)
  end
end
