class VerificationExpirationsMailer < ApplicationMailer
  def expired(to, subject_id)
    @subject_id = subject_id

    mail to: to, subject: I18n.t('mailers.verification_expirations.subject')
  end
end
