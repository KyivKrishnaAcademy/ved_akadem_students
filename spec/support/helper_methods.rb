module HelperMethods
  def login_as_admin(admin=nil)
    @admin = admin
    @admin ||= create(:person, :admin)
    login_as(@admin)
    visit '/'
  end

  def login_as_user(user=nil)
    @user = user
    @user ||= create(:person)
    login_as(@user)
    visit '/'
  end

  def all_activities
    @all_activities ||= PeopleController.action_methods.map { |action| 'person:' << action } +
                        (AkademGroupsController.action_methods - %w[autocomplete_person get_prefix get_autocomplete_order get_autocomplete_items autocomplete_person_complex_name]).map { |action| 'akadem_group:' << action } +
                        %w{person:crop_image} - %w{person:show_photo} +
                        StudyApplicationsController.action_methods.map { |action| 'study_application:' << action } +
                        %w{questionnaire:update_all}
  end
end
