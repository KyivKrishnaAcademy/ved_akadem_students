class GroupTransactionsMailer < ApplicationMailer
  def leave_the_group(group, person)
    general_mail(group, person, t('mail.group.leave.subject', group_title: group.title))
  end

  def join_the_group(group, person)
    general_mail(group, person, t('mail.group.join.subject', group_title: group.title))
  end

  private

  def general_mail(group, person, subject)
    @group  = group
    @person = person

    I18n.with_locale(person.locale) do
      mail(
        to: person.email,
        reply_to: group.administrator.email,
        subject: subject
      )
    end
  end
end
