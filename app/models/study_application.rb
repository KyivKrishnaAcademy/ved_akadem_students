class StudyApplication < ActiveRecord::Base
  belongs_to :person
  belongs_to :program
  has_and_belongs_to_many :questionnaires

  validates :program_id, :person_id, presence: true
end
