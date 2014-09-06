class Program < ActiveRecord::Base
  has_many :study_applications, dependent: :destroy
  has_and_belongs_to_many :questionnaires

  validates :title, :description, presence: true
end
