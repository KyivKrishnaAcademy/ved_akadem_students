# Preview all emails at http://localhost:3000/rails/mailers/programm_applications
class ProgrammApplicationsPreview < ActionMailer::Preview
  # Preview this email at http://localhost:3000/rails/mailers/programm_applications/submitted
  def submitted
    ProgrammApplicationsMailer.submitted
  end
end
