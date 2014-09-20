class Program < ActiveRecord::Base
  serialize :courses_ua, Array
  serialize :courses_ru, Array

  has_many :study_applications, dependent: :destroy
  has_and_belongs_to_many :questionnaires

  validates :title_ua, :title_ru, :description_ua, :description_ru, presence: true
end
