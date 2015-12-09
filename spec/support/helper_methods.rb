module HelperMethods
  def login_as_admin
    login_as(create(:person, :admin))
  end

  def login_as_user
    login_as(create(:person))
  end

  def all_activities
    @all_activities ||= (person_activities + academic_group_activities + study_application_activities +
      %w(questionnaire:update_all) + course_activities + class_schedule_activities +
      certificate_template_activities + assigned_cert_template_activities).sort
  end

  def screenshot
    sleep 10

    save_screenshot(Rails.root.join 'tmp/capybara', 'Screenshot' << Time.now.strftime('%Y%m%d%H%M%S%L') << '.png')
  end

  def select2_single(klass, option)
    select2_common(klass, option)

    find(".#{klass} .select2-selection__rendered[title='#{option}']")
  end

  def select2_multi(klass, option)
    select2_common(klass, option)

    find(".#{klass} li.select2-selection__choice", text: option)
  end

  def init_schedules_mv
    ClassScheduleWithPeople.connection.execute("REFRESH MATERIALIZED VIEW #{ClassScheduleWithPeople.table_name}")
  end

  private

  def select2_common(klass, option)
    find(".#{klass} span.select2-container").click
    find('li.select2-results__option', text: option).click
  end

  def person_activities
    PeopleController.action_methods.map { |action| 'person:' << action } +
      %w(person:view_psycho_test_result person:crop_image person:move_to_group
         person:remove_from_groups) - %w(person:show_photo)
  end

  def academic_group_activities
    (
      AcademicGroupsController.action_methods -
        %w(autocomplete_person get_prefix get_autocomplete_order
           get_autocomplete_items autocomplete_person_complex_name) +
        %w(group_list_pdf attendance_template_pdf)
    ).map { |action| 'academic_group:' << action }
  end

  def study_application_activities
    StudyApplicationsController.action_methods.map { |action| 'study_application:' << action }
  end

  def course_activities
    CoursesController.action_methods.map { |action| 'course:' << action }
  end

  def class_schedule_activities
    ClassSchedulesController.action_methods.map { |action| 'class_schedule:' << action }
  end

  def certificate_template_activities
    (
      CertificateTemplatesController.action_methods - %w(markup finish background)
    ).map { |action| 'certificate_template:' << action }
  end

  def assigned_cert_template_activities
    AssignedCertTemplatesController.action_methods.map { |action| 'assigned_cert_template:' << action }
  end
end
