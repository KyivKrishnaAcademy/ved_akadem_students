class ExaminationResult < ApplicationRecord
  belongs_to :examination
  belongs_to :person
end
