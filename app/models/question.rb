class Question < ActiveRecord::Base
  serialize :data, Hash

  belongs_to :questionnaire
  has_many :answers, dependent: :destroy

  accepts_nested_attributes_for :answers

  def answers_by_person(person)
    answers.select { |a| a.person_id == person.id }
  end
end
