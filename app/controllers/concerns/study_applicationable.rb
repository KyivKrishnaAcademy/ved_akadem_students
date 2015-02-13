module StudyApplicationable
  private

  def preset_applications_variables(person = current_person)
    @person_decorator  = person_decorator(person)
    @programs          = programs(current_person)
    @study_application = StudyApplication.new(person_id: @person_decorator.id) if @person_decorator.present?
  end

  def person_decorator(person)
    return if person.blank?

    if person.is_a?(Person)
      PersonDecorator.new(person)
    else
      PersonDecorator.new(Person.find(person))
    end
  end

  def programs(person)
    return if person.blank?

    if  person.can_act?('study_application:create')
      Program.all
    else
      Program.where(visible: true)
    end
  end
end
