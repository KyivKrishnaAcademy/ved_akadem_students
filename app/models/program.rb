class Program < ActiveRecord::Base
  has_many :study_applications, dependent: :destroy

  validates :title, :description, presence: true
end
