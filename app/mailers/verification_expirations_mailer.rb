class VerificationExpirationsMailer < ApplicationMailer
  def expired(to, subject_id)
    @subject_id = subject_id

    mail to: to, subject: 'Верификация студента'
  end
end
