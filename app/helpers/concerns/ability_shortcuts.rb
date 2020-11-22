module AbilityShortcuts
  def show_people_menu?
    current_person&.can_act?(%w[person:index person:new])
  end

  def show_academic_groups_menu?
    current_person&.can_act?(%w[academic_group:index academic_group:new])
  end

  def show_certificate_templates_menu?
    current_person&.can_act?(%w[certificate_template:index certificate_template:new])
  end

  def show_courses_menu?
    current_person&.can_act?(%w[course:index course:new])
  end

  def show_class_schedules_menu?
    current_person&.can_act?(%w[class_schedule:index class_schedule:new])
  end

  def show_journal_link?
    current_person&.can_act?('paper_trail/version:show')
  end

  def show_statistics_yearly_link?
    current_person&.can_act?('statistics_controller:yearly')
  end
end
