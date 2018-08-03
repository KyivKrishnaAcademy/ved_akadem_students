class Note < ApplicationRecord
  belongs_to :person

  validates :date, :message, :person, presence: true

  has_paper_trail
end
