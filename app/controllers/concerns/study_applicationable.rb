module StudyApplicationable
  extend ActiveSupport::Concern

  private

  def set_programs_and_new_application
    @programs           = Program.all
    @study_application  = StudyApplication.new
  end
end
