class Course < ApplicationRecord
  has_many :class_schedules, dependent: :destroy
  has_many :teacher_specialities, dependent: :destroy
  has_many :teacher_profiles, through: :teacher_specialities
  has_many :examinations

  validates :title, :description, presence: true

  has_paper_trail

  def label_for_select
    variant.present? ? "#{title}, variant: #{variant}" : title
  end
end
