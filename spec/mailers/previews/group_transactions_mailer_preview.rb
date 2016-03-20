# Preview all emails at http://localhost:3000/rails/mailers/group_transactions_mailer
class GroupTransactionsMailerPreview < ActionMailer::Preview
  def leave_the_group_uk
    GroupTransactionsMailer.leave_the_group(AcademicGroup.first, Person.where(locale: :uk).first)
  end

  def leave_the_group_ru
    GroupTransactionsMailer.leave_the_group(AcademicGroup.first, Person.where(locale: :ru).first)
  end
end
