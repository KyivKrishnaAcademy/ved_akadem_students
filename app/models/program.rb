class Program < ActiveRecord::Base
  has_many :study_applications, dependent: :destroy

  validates :title, presence: true
end
