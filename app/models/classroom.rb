class Classroom < ApplicationRecord
  include Ilikable

  has_many :class_schedules, dependent: :destroy

  validates :title, presence: true

  has_paper_trail
end
