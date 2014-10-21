class Program < ActiveRecord::Base
  serialize :courses_uk, Array
  serialize :courses_ru, Array

  has_many :study_applications, dependent: :destroy
  has_and_belongs_to_many :questionnaires

  validates :title_uk, :title_ru, :description_uk, :description_ru, presence: true
end
