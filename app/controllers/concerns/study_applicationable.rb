module StudyApplicationable
  private

  def set_programs_and_new_application(person = current_person)
    @person_decorator   = person.is_a?(String) ? PersonDecorator.new(Person.find(person)) : PersonDecorator.new(person)
    @programs           = current_person.can_act?('study_application:create') ? Program.all : Program.where(visible: true)
    @study_application  = StudyApplication.new
  end
end
