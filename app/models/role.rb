class Role < ApplicationRecord
  has_and_belongs_to_many :people

  validates :name, presence: true, length: { maximum: 30 }
  validates :activities, presence: true

  has_paper_trail
end
