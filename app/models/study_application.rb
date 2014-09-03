class StudyApplication < ActiveRecord::Base
  validates :program_id, :person_id, presence: true
end
