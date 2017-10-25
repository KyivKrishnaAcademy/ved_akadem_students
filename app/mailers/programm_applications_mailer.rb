class ProgrammApplicationsMailer < ApplicationMailer
  def submitted(student, program)
    @student = student
    @program = program

    I18n.with_locale(program.manager.locale) do
      mail(
        to: program.manager.email,
        subject: t('mail.programm_applications.submitted.subject', name: student.complex_name)
      )
    end
  end
end
