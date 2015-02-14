module HelperMethods
  def login_as_admin(admin = nil)
    @admin = admin
    @admin ||= create(:person, :admin)
    login_as(@admin)
    visit '/'
  end

  def login_as_user(user = nil)
    @user = user
    @user ||= create(:person)
    login_as(@user)
    visit '/'
  end

  def all_activities
    @all_activities ||= (people_activities + academic_groups_activities + study_applications_activities +
      %w(questionnaire:update_all)).sort
  end

  def choose_autocomplete_result(item_text, input_selector = 'input[data-autocomplete]')
    page.execute_script %{ $('#{input_selector}').trigger("focus") }
    page.execute_script %{ $('#{input_selector}').trigger("keydown") }

    item_selector = "ul.ui-autocomplete li.ui-menu-item:contains('#{item_text}')"

    expect(page).to have_selector('ul.ui-autocomplete li.ui-menu-item', text: item_text)

    page.execute_script %{ $("#{item_selector}").trigger("mouseenter").trigger("click"); }
  end

  def screenshot
    sleep 10

    save_screenshot(Rails.root.join 'tmp/capybara', 'Screenshot' << Time.now.strftime('%Y%m%d%H%M%S%L') << '.png')
  end

  private

  def people_activities
    PeopleController.action_methods.map { |action| 'person:' << action } +
      %w(person:view_psycho_test_result person:crop_image) - %w(person:show_photo)
  end

  def academic_groups_activities
    (
      AcademicGroupsController.action_methods - %w(autocomplete_person get_prefix get_autocomplete_order
                                                   get_autocomplete_items autocomplete_person_complex_name)
    ).map { |action| 'academic_group:' << action }
  end

  def study_applications_activities
    StudyApplicationsController.action_methods.map { |action| 'study_application:' << action }
  end
end
