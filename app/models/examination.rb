class Examination < ApplicationRecord
  belongs_to :course
  has_many :examination_results, dependent: :restrict_with_error

  validates :title, presence: true
  validate :passing_score_in_range

  has_paper_trail

  private

  def passing_score_in_range
    range = min_result..max_result

    return true if range.include?(passing_score)

    errors.add(:passing_score, :inclusion, value: range)
  end
end
