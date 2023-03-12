module HelperMethods
  def login_as_admin
    login_as(create(:person, :admin))
  end

  def login_as_user
    login_as(create(:person))
  end

  def all_activities
    @all_activities ||= (person_activities + academic_group_activities + study_application_activities +
      %w[questionnaire:update_all group_participation:destroy sidekiq:admin] + course_activities +
      class_schedule_activities + certificate_template_activities + journal_activities + examination_activities +
      attendance_activities + examination_results + note_activities + statistics_activities +
      questionnaire_activities + certificate_template_font_activities + certificate_activities +
      certificate_import_activities + program_activities
    ).sort
  end

  def screenshot
    sleep 10

    file_path = Rails.root.join('tmp/capybara', 'Screenshot' << Time.zone.now.strftime('%Y%m%d%H%M%S%L')).to_s

    save_screenshot(file_path + '.png')
    save_page(file_path + '.html')
  end

  def select2_single(klass, option)
    select2_common(klass, option)

    find(".#{klass} .select2-selection__rendered[title='#{option}']")
  end

  def select2_multi(klass, option)
    select2_common(klass, option)

    find(".#{klass} li.select2-selection__choice", text: option)
  end

  def select2_remove_multi(select2_id, option_title)
    page.execute_script %{
      $('li.select2-selection__choice[title="#{option_title}"]').find('.select2-selection__choice__remove').click();
      $('select##{select2_id}').select2('close');
    }
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
      %w(person:view_psycho_test_result person:crop_image person:move_to_group person:verify) - %w(person:show_photo)
  end

  def academic_group_activities
    (
      AcademicGroupsController.action_methods -
        %w(autocomplete_person get_prefix get_autocomplete_order
           get_autocomplete_items autocomplete_person_complex_name) +
        %w(group_list_pdf attendance_template_pdf statistics)
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

  def questionnaire_activities
    QuestionnairesController.action_methods.map { |action| 'questionnaire:' << action }
  end

  def certificate_activities
    ['certificate:show']
  end

  def certificate_template_activities
    CertificateTemplatesController.action_methods.map { |action| 'certificate_template:' << action }
  end

  def certificate_template_font_activities
    CertificateTemplateFontsController.action_methods.map { |action| 'certificate_template_font:' << action }
  end

  def program_activities
    ProgramsController.action_methods.map { |action| 'program:' << action }
  end

  def journal_activities
    JournalsController.action_methods.map { |action| 'paper_trail/version:' << action }
  end

  def note_activities
    NotesController.action_methods.map { |action| "note:#{action}" } + %w(index)
  end

  def examination_activities
    %w(new update index create edit destroy show).map { |action| 'examination:' << action }
  end

  def attendance_activities
    %w(ui_update ui_create ui_destroy).map { |action| 'attendance:' << action }
  end

  def examination_results
    %w(ui_update ui_create ui_destroy).map { |action| 'examination_result:' << action }
  end

  def statistics_activities
    %w(yearly).map { |action| 'statistics_controller:' << action }
  end

  def certificate_import_activities
    %w(new create).map { |action| 'certificate_imports_controller:' << action }
  end
end
