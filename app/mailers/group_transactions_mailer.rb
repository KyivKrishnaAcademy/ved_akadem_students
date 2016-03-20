class GroupTransactionsMailer < ApplicationMailer
  def leave_the_group(group, person)
    @group  = group
    @person = person

    I18n.with_locale(person.locale) do
      mail(to: person.email, subject: t('mail.group.leave.subject', group_title: group.title))
    end
  end
end
