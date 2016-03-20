class GroupParticipation < ActiveRecord::Base
  belongs_to :student_profile
  belongs_to :academic_group

  before_save :set_join_date

  validates :academic_group, :student_profile, presence: true

  has_paper_trail

  def leave!
    update(leave_date: DateTime.current)
  end

  private

  def set_join_date
    self.join_date = DateTime.current if join_date.blank?
  end
end
