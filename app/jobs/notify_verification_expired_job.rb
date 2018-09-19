class NotifyVerificationExpiredJob < ApplicationJob
  queue_as :default

  def perform(subject_id)
    people_to_notify.find_each { |p| VerificationExpirationsMailer.expired(p.email, subject_id).deliver_later }
  end

  private

  def people_to_notify
    Person.joins(:roles).where('roles.activities @> ARRAY[?]::varchar[]', 'person:verify')
  end
end
