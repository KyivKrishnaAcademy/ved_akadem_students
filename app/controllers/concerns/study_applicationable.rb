module StudyApplicationable
  private

  def set_programs_and_new_application
    @person_decorator   = PersonDecorator.new(current_person)
    @programs           = Program.where(visible: true)
    @study_application  = StudyApplication.new
  end
end
