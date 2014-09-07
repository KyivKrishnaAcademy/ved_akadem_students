module StudyApplicationable
  extend ActiveSupport::Concern

  private

  def set_programs_and_new_application
    @person_decorator   = PersonDecorator.new(current_person)
    @programs           = Program.all
    @study_application  = StudyApplication.new
  end
end
