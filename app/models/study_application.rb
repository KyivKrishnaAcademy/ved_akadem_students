class StudyApplication < ApplicationRecord
  belongs_to :person
  belongs_to :program, counter_cache: true

  validates :person_id, uniqueness: true
  validates :program, :person, presence: true

  has_paper_trail
end
