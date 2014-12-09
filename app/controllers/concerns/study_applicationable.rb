module StudyApplicationable
  private

  def set_programs_and_new_application(person = current_person, admin = false)
    @person_decorator   = person.is_a?(String) ? PersonDecorator.new(Person.find(person)) : PersonDecorator.new(person)
    @programs           = admin ? Program.all : Program.where(visible: true)
    @study_application  = StudyApplication.new
  end
end
