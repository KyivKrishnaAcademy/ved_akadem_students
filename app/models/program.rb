class Program < ApplicationRecord
  serialize :courses_uk, Array
  serialize :courses_ru, Array

  has_many :study_applications, dependent: :destroy
  has_and_belongs_to_many :questionnaires
  belongs_to :manager, class_name: 'Person'

  validates :title_uk, :title_ru, :description_uk, :description_ru, :manager, presence: true

  has_paper_trail
end
