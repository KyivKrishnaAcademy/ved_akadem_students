class Program < ApplicationRecord
  has_many :study_applications, dependent: :destroy

  belongs_to :manager, class_name: 'Person'
  has_and_belongs_to_many :questionnaires

  validates :title_uk, :title_ru, :description_uk, :description_ru, :manager, presence: true

  has_paper_trail
end
