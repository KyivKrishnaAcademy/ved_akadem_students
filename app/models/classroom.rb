class Classroom < ActiveRecord::Base
  has_many :class_schedules, dependent: :destroy

  validates :title, presence: true
end
