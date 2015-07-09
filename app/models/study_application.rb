class StudyApplication < ActiveRecord::Base
  belongs_to :person
  belongs_to :program

  validates :program_id, :person_id, presence: true

  has_paper_trail
end
