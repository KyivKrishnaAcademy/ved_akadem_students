class Note < ApplicationRecord
  belongs_to :person

  validates :date, :message, :person, presence: true
end
