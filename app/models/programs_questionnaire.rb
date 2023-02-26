class ProgramsQuestionnaire < ApplicationRecord
  belongs_to :program, counter_cache: :questionnaires_count
  belongs_to :questionnaire

  has_paper_trail
end
