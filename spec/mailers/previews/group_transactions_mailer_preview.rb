# Preview all emails at http://localhost:3000/rails/mailers/group_transactions_mailer
class GroupTransactionsMailerPreview < ActionMailer::Preview
  def leave_the_group_uk
    leave_the_group(:uk)
  end

  def leave_the_group_ru
    leave_the_group(:ru)
  end

  def join_the_group_uk
    join_the_group(:uk)
  end

  def join_the_group_ru
    join_the_group(:ru)
  end

  private

  def leave_the_group(locale)
    GroupTransactionsMailer.leave_the_group(AcademicGroup.first, Person.where(locale: locale).first)
  end

  def join_the_group(locale)
    GroupTransactionsMailer.join_the_group(AcademicGroup.first, Person.where(locale: locale).first)
  end
end
