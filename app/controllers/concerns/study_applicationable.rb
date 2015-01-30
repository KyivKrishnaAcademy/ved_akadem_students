module StudyApplicationable
  private

  def set_programs_and_new_application(person = current_person)
    @person_decorator   = if person.present?
                            person.is_a?(Person) ? PersonDecorator.new(person) : PersonDecorator.new(Person.find(person))
                          end
    @programs           = current_person.present? && current_person.can_act?('study_application:create') ? Program.all : Program.where(visible: true)
    @study_application  = StudyApplication.new(person_id: @person_decorator.id) if @person_decorator.present?
  end
end
