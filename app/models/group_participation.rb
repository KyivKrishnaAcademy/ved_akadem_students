class GroupParticipation < ApplicationRecord
  belongs_to :student_profile
  belongs_to :academic_group

  before_save :set_join_date

  validates :academic_group, :student_profile, presence: true

  has_paper_trail

  def leave!
    return if leave_date.present?

    update(leave_date: Time.zone.now)

    person = student_profile.person

    return if person.fake_email? || person.spam_complain? || !academic_group.active?

    GroupTransactionsMailer.leave_the_group(academic_group, person).deliver_later
  end

  private

  def set_join_date
    self.join_date = Time.zone.now if join_date.blank?
  end
end
