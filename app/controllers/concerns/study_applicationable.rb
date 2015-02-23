module StudyApplicationable
  private

  def preset_applications_variables(person = current_person)
    @application_person    = application_person(person)
    @programs              = programs(current_person)
    @new_study_application = StudyApplication.new(person_id: @application_person.id) if @application_person.present?
  end

  def application_person(person)
    return if person.blank?

    person.is_a?(Person) ? person.reload : Person.find(person)
  end

  def programs(person)
    return if person.blank?

    if person.can_act?('study_application:create')
      Program.all
    else
      Program.where(visible: true)
    end
  end
end
