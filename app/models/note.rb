class Note < ApplicationRecord
  belongs_to :person

  validates :date, :message, presence: true

  has_paper_trail
end
