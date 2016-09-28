class StudyApplication < ActiveRecord::Base
  belongs_to :person
  belongs_to :program

  validates :person_id, uniqueness: true
  validates :program, :person, presence: true

  has_paper_trail
end
