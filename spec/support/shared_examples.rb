# views

shared_examples 'academic group new and edit' do |action|
  let(:title) { I18n.t("academic_groups.#{action}.title") }

  it { is_expected.to have_title(full_title(title)) }
  it { is_expected.to have_selector('h1', text: title) }

  describe 'form' do
    let(:form) { 'form.' << action << '_academic_group' }

    it { is_expected.to have_selector(form) }
    it { is_expected.to have_selector("#{form} label", text: I18n.t('activerecord.attributes.academic_group.title')) }
    it { is_expected.to have_selector("#{form} input#academic_group_title") }
    it { is_expected.to have_selector("#{form} input#academic_group_establ_date") }
    it {
      is_expected.to have_selector("#{form} label", text: I18n.t('activerecord.attributes.academic_group.message_uk'))
    }
    it {
      is_expected.to have_selector("#{form} label", text: I18n.t('activerecord.attributes.academic_group.message_ru'))
    }
    it { is_expected.to have_selector("#{form} input#academic_group_group_description") }
    it { is_expected.to have_selector("#{form} button[type=\"submit\"]"), text: I18n.t("academic_groups.#{action}.submit") }
    it do
      is_expected.to have_selector("#{form} label",
                                   text: I18n.t('activerecord.attributes.academic_group.group_description'))
    end
    it do
      is_expected.to have_selector("#{form} label", text: I18n.t('activerecord.attributes.academic_group.establ_date'))
    end
  end
end

shared_examples 'index.html' do |headers|
  describe 'title and h1' do
    Then { expect(page).to have_title(full_title(title)) }
    And  { expect(find('body')).to have_selector('h1', text: h1) }
  end

  describe 'table' do
    Then { expect(find('.table')).to have_selector('tr.' << row_class, count: models_count) }

    headers.each do |header|
      And { expect(find('.table')).to have_selector('th', text: header) }
    end
  end
end

# routes
shared_examples 'CRUD' do |controller|
  it { expect(get:    "/#{controller}").to route_to("#{controller}#index") }
  it { expect(post:   "/#{controller}").to route_to("#{controller}#create") }
  it { expect(get:    "/#{controller}/new").to route_to("#{controller}#new") }
  it { expect(get:    "/#{controller}/1/edit").to route_to("#{controller}#edit", id: '1') }
  it { expect(get:    "/#{controller}/1").to route_to("#{controller}#show", id: '1') }
  it { expect(patch:  "/#{controller}/1").to route_to("#{controller}#update", id: '1') }
  it { expect(put:    "/#{controller}/1").to route_to("#{controller}#update", id: '1') }
  it { expect(delete: "/#{controller}/1").to route_to("#{controller}#destroy", id: '1') }
end

# controllers
def create_model(model)
  create model.name.underscore.to_sym
end

shared_examples 'GET' do |variable, model, action|
  case action
  when :new
    Given(:m) do
      3.times { create_model model }
      model.all
    end

    Given(:get_act) { get action }
  when :show, :edit
    Given(:m)       { create_model model }
    Given(:get_act) { get action, params: { id: m } }
  end

  When { get_act }

  context ":#{action}" do
    describe 'responce' do
      Then { expect(response).to be_success }
    end

    if action == :new
      describe "assigns @#{variable} a new #{model} model" do
        Then { expect(assigns(variable)).to be_a_new(model) }
      end
    else
      case action
      when :show, :edit
        describes = "assigns @#{variable} to be right #{model}"
      end

      describe describes do
        Then { expect(assigns(variable)).to eq(m) }
      end
    end
  end
end

shared_examples "DELETE 'destroy'" do |model|
  Given { create_model model }

  Given(:del_person) { delete 'destroy', params: { id: model.last.id } }

  context 'on success' do
    describe 'model count and redirect' do
      Then { expect { del_person }.to change(model, :count).by(-1) }
      And  { expect(del_person).to redirect_to(action: :index) }
    end

    describe 'flash' do
      When { del_person }

      Then { is_expected.to set_flash[:success] }
    end
  end

  context 'on failure' do
    Given { allow_any_instance_of(model).to receive_message_chain(:destroy, :destroyed?).and_return(false) }
    Given { request.env['HTTP_REFERER'] = 'where_i_came_from' }

    describe 'model count and redirect' do
      Then { expect { del_person }.not_to change(model, :count) }
      And  { expect(del_person).to redirect_to('where_i_came_from') }
    end

    describe 'flash' do
      When { del_person }

      Then { is_expected.to set_flash[:danger] }
    end
  end
end

shared_examples :controller_params_subclass do |subclass, model|
  describe subclass.to_s do
    describe '.filter' do
      it 'returns the cleaned params' do
        expect(
          subclass.filter(
            ActionController::Parameters
              .new(model => { foo: 'foo' }.merge(mod_params))
          )
        ).to eq(ActionController::Parameters.new(mod_params).permit!)
      end
    end
  end
end

# requests

shared_examples 'renders _form on New and Edit pages' do
  describe 'New page' do
    When { get new_path }

    Then { expect(response).to render_template(partial: '_form') }
  end

  describe 'Edit page' do
    When { get edit_path }

    Then { expect(response).to render_template(partial: '_form') }
  end
end

# integration

shared_examples :integration_delete_model do |model|
  Given(:m_name_underscore) { model.name.underscore }

  When { visit method(('' << m_name_underscore << '_path').to_sym).call(create(m_name_underscore.to_sym)) }

  describe 'flash' do
    When { click_link I18n.t('links.delete') }

    Then do
      expect(page).to have_selector('.alert-success', text: "#{m_name_underscore.humanize.titleize} record deleted!")
    end
  end

  describe 'model count' do
    Then { expect { click_link I18n.t('links.delete') }.to change { model.count }.by(-1) }
  end
end

shared_examples :alert_success_updated do |thing|
  Then { expect(find('body')).to have_selector('.alert-success', text: "#{thing} was successfully updated.") }
end

shared_examples :valid_fill_in do |h, model_human|
  describe h[:field] do
    When do
      fill_in h[:field], with: h[:value]
      click_button "Зберегти #{model_human}"
    end

    Then { expect(find('body')).to have_content(h[:test_field]) }

    it_behaves_like :alert_success_updated, model_human
  end
end

def underscore_humanize(str)
  str.underscore.humanize
end

shared_examples :valid_select do |model_name, field_name, value, content|
  When do
    select value, from: field_name
    click_button "Зберегти #{underscore_humanize(model_name)}"
  end

  Then { expect(find('body')).to have_content(content) }
  it_behaves_like :alert_success_updated, underscore_humanize(model_name)
end

shared_examples :allow_with_activities do |activites|
  context "with #{activites.join(' ')} only" do
    Given { user.roles << create(:role, activities: activites) }

    context 'allow' do
      Then { is_expected.to permit(user, record) }
    end
  end

  context "without #{activites.join(' ')}" do
    Given { user.roles << create(:role, activities: all_activities - activites) }

    context 'disallow' do
      Then { is_expected.not_to permit(user, record) }
    end
  end
end

shared_examples :study_applications do |admin|
  Given!(:program) { create(:program, title_uk: 'Школа Бхакти', description_uk: 'Описание 1', position: 0) }
  Given { create(:program, title_uk: 'Бхакти Шастры', description_uk: 'Описание 2', position: 1) }
  Given { create(:program, title_uk: 'Invisible Program', visible: false, position: 2) }
  Given { StudyApplication.create(person_id: user.id, program_id: program.id) } if admin

  Given(:have_apply_button) { have_selector('button.btn-submit', text: I18n.t('links.apply_to_program')) }
  Given(:have_withdraw_button) { have_selector('button.btn-submit', text: I18n.t('links.withdraw')) }

  context 'with application' do
    Given { StudyApplication.create(person_id: person.id, program_id: program.id) }
    Given { person.questionnaires << create(:questionnaire, title_uk: 'Психо тест') }

    describe 'have elements' do
      Then { expect(find('#study_application')).to have_content('Школа Бхакти') }
      And  { expect(find('#study_application')).not_to have_content('Бхакти Шастры') }
      And  { expect(find('#study_application')).to have_withdraw_button }
      And  { expect(find('#pending_docs')).to have_css('li', text: 'Заповнити Психо тест') }
      And  { expect(find('#pending_docs')).to have_css('li', text: 'Додати фотографію до профілю') }
    end

    describe 'withdraw', :js do
      When { find('.program .btn-danger').click }

      Then { expect(find('#study_application')).to have_apply_button }
      And  { expect(find('#study_application')).to have_content('Школа Бхакти') }
      And  { expect(find('#study_application')).to have_content('Бхакти Шастры') }
    end
  end

  context 'without application' do
    Given(:programs) { all('#study_application .panel-info') }

    describe 'have elements' do
      Then { expect(programs.first).to have_content('Школа Бхакти') }
      And  { expect(programs.first).to have_content('Описание 1') }
      And  { expect(programs.first).to have_apply_button }
      And  { expect(programs[1]).to have_content('Бхакти Шастры') }
      And  { expect(programs[1]).to have_content('Описание 2') }
      And  { expect(programs[1]).to have_apply_button }
      And  { expect(find('#study_application')).not_to have_content('Invisible Program') } unless admin
      And  { expect(find('#study_application')).to have_content('Invisible Program') } if admin
    end

    describe 'apply', :js do
      When { programs.first.find('.btn-success').click }

      Then { expect(find('#study_application')).to have_withdraw_button }
      And  { expect(find('#study_application')).to have_content('Школа Бхакти') }
      And  { expect(find('#study_application')).not_to have_content('Бхакти Шастры') }
    end
  end
end

shared_examples :not_authenticated do
  Then  { expect(response).to redirect_to(new_person_session_path) }
  And   { is_expected.to set_flash[:alert].to(I18n.t('devise.failure.unauthenticated')) }
end

shared_examples :not_authenticated_js do
  When  { action }

  Then { expect(response.status).to eq(401) }
  And  { expect(response.body).to eq(I18n.t('devise.failure.unauthenticated')) }
end

shared_examples :failed_auth_crud do |sub_example, skipped_actions = []|
  describe sub_example.to_s do
    Given(:additional_params) { respond_to?(:nested_route_params) ? nested_route_params : {} }
    Given(:default_id_param) { { id: respond_to?(:default_id) ? default_id : 1 } }

    unless skipped_actions.include?(:index)
      context '#index' do
        When { get :index, params: additional_params }

        it_behaves_like sub_example
      end
    end

    unless skipped_actions.include?(:create)
      context '#create' do
        When { post :create, params: additional_params.deep_merge(params) }

        it_behaves_like sub_example
      end
    end

    unless skipped_actions.include?(:new)
      context '#new' do
        When { get :new, params: additional_params }

        it_behaves_like sub_example
      end
    end

    unless skipped_actions.include?(:edit)
      context '#edit' do
        When { get :edit, params: additional_params.deep_merge(default_id_param) }

        it_behaves_like sub_example
      end
    end

    unless skipped_actions.include?(:show)
      context '#show' do
        When { get :show, params: additional_params.deep_merge(default_id_param) }

        it_behaves_like sub_example
      end
    end

    unless skipped_actions.include?(:update)
      context '#update' do
        When { patch :update, params: additional_params.deep_merge(default_id_param) }

        it_behaves_like sub_example
      end
    end

    unless skipped_actions.include?(:destroy)
      context '#destroy' do
        When { delete :destroy, params: additional_params.deep_merge(default_id_param) }

        it_behaves_like sub_example
      end
    end
  end
end

shared_examples_for :not_authorized do
  Then { expect(response).to redirect_to(root_path) }
  And  { expect(response).to render_template(nil) }
  And  { is_expected.to set_flash[:danger].to(I18n.t(:not_authorized)) }
end

shared_examples_for :ui_not_authorized do
  Then { expect(JSON.parse(response.body, symbolize_names: true)).to eq(error: 'not_authorized') }
  And  { expect(response.status).to be(401) }
end

shared_examples_for :ui_not_authenticated do
  Then do
    expect(JSON.parse(response.body, symbolize_names: true)).to eq(error: I18n.t('devise.failure.unauthenticated'))
  end

  And { expect(response.status).to be(401) }
end

shared_examples_for :class_schedule_ui_index do
  permissions :ui_index? do
    context 'permit with class_schedule:edit' do
      Given { user.roles << [create(:role, activities: %w[class_schedule:edit])] }

      Then  { is_expected.to permit(user, Course) }
    end

    context 'permit with class_schedule:new' do
      Given { user.roles << [create(:role, activities: %w[class_schedule:new])] }

      Then  { is_expected.to permit(user, Course) }
    end

    context 'not permit without roles' do
      Then  { is_expected.not_to permit(user, Course) }
    end

    context 'not permit with all other' do
      Given(:permitted_activities) do
        %w[
          class_schedule:edit
          class_schedule:new
          academic_group:edit
          academic_group:new
        ]
      end

      Given { user.roles << [create(:role, activities: all_activities - permitted_activities)] }

      Then  { is_expected.not_to permit(user, Course) }
    end
  end
end

shared_examples_for :ui_controller_index do |index_action, interaction, permitted_activities|
  describe 'not signed in' do
    context "##{index_action}" do
      When { get index_action, format: :json }

      it_behaves_like :ui_not_authenticated
    end
  end

  describe 'signed in' do
    Given(:person) { build_stubbed(:person, id: 1) }

    Given { allow(request.env['warden']).to receive(:authenticate!) { person } }
    Given { allow(controller).to receive(:current_person) { person } }
    Given { allow(person).to receive(:class).and_return(Person) }

    describe 'as regular user' do
      context "##{index_action}" do
        When { get index_action, format: :json }

        it_behaves_like :ui_not_authorized
      end
    end

    describe 'as authorized user' do
      Given(:roles) { double('roles', any?: true, title: 'Role') }

      Given { allow(person).to receive(:roles).and_return(roles) }
      Given { allow(roles).to receive_message_chain(:pluck, :flatten) { permitted_activities } }

      context "##{index_action}" do
        Then { expect(interaction).to receive(:new) }
        And  { get index_action, format: :json }
      end
    end
  end
end

shared_examples_for :class_schedules_loadable do
  Given(:group) { create :academic_group, title: group_title }
  Given(:course) { create :course, title: course_title }
  Given(:subject) { 'Шудха Кришна бхакти' }
  Given(:classroom) { create :classroom, title: classroom_title }
  Given(:start_time) { '01.01.2019 12:01' }
  Given(:group_title) { 'ШБ11-9' }
  Given(:finish_time) { '01.01.2019 13:02' }
  Given(:result_time) { 'Вт 01.01.19 12:01 - 13:02' }
  Given(:course_title) { 'Bhakti school' }
  Given(:classroom_title) { 'Antardwipa' }
  Given(:teacher_profile) { create :teacher_profile }

  Given(:full_schedule) do
    create(
      :class_schedule,
      course: course,
      classroom: classroom,
      teacher_profile: teacher_profile,
      subject: subject,
      start_time: start_time,
      finish_time: finish_time,
      academic_groups: [group]
    )
  end

  Given(:optional_schedule) do
    create(
      :class_schedule,
      course: course,
      classroom: classroom,
      start_time: start_time,
      finish_time: finish_time
    )
  end

  Given(:group_can_view) { false }
  Given(:course_can_view) { false }
  Given(:lector_can_view) { false }
  Given(:schedule_can_edit) { false }
  Given(:schedule_can_delete) { false }

  Given(:path_helper) { ::Rails.application.routes.url_helpers }

  Given(:expected_full_payload) do
    {
      classSchedules: [
        {
          id: full_schedule.id,
          subject: subject,
          course: {
            id: course.id,
            title: course_title,
            canView: course_can_view,
            path: path_helper.course_path(course)
          },
          lector: {
            id: teacher_profile.person.id,
            path: path_helper.person_path(teacher_profile.person),
            canView: lector_can_view,
            complexName: "#{teacher_profile.person.surname} #{teacher_profile.person.name}"
          },
          academicGroups: [
            {
              id: group.id,
              title: group_title,
              canView: group_can_view,
              path: path_helper.academic_group_path(group)
            }
          ],
          classroom: classroom_title,
          time: result_time,
          canEdit: schedule_can_edit,
          canDelete: schedule_can_delete,
          editPath: path_helper.edit_class_schedule_path(full_schedule),
          deletePath: path_helper.class_schedule_path(full_schedule)
        }
      ],
      pages: 1
    }
  end

  Given(:paginated_array) { Kaminari.paginate_array(array_for_pagination).page(1).per(10) }

  Given { allow(ClassScheduleWithPeople).to receive(:personal_schedule_by_direction).and_return(paginated_array) }
  Given { allow(ClassSchedule).to receive(:by_group).and_return(paginated_array) }

  describe 'optional schedule' do
    Given { allow(optional_schedule).to receive(:real_class_schedule).and_return(optional_schedule) }

    Given(:array_for_pagination) { [optional_schedule] }

    Given(:expected_optional_payload) do
      {
        classSchedules: [
          {
            id: optional_schedule.id,
            subject: nil,
            course: {
              id: course.id,
              title: course_title,
              canView: false,
              path: path_helper.course_path(course)
            },
            lector: nil,
            academicGroups: [],
            classroom: classroom_title,
            time: result_time,
            canEdit: false,
            canDelete: false,
            editPath: path_helper.edit_class_schedule_path(optional_schedule),
            deletePath: path_helper.class_schedule_path(optional_schedule)
          }
        ],
        pages: 1
      }
    end

    Then { expect(interaction.as_json).to eq(expected_optional_payload) }
  end

  describe 'full schedule' do
    Given { allow(full_schedule).to receive(:real_class_schedule).and_return(full_schedule) }

    Given(:user) { create :person, roles: [create(:role, activities: activities)] }
    Given(:activities) { ['some'] }
    Given(:array_for_pagination) { [full_schedule] }

    describe 'no permissions' do
      Then { expect(interaction.as_json).to eq(expected_full_payload) }
    end

    describe 'can view group' do
      Given(:group_can_view) { true }
      Given(:activities) { ['academic_group:show'] }

      Then { expect(interaction.as_json).to eq(expected_full_payload) }
    end

    describe 'can view course' do
      Given(:course_can_view) { true }
      Given(:activities) { ['course:show'] }

      Then { expect(interaction.as_json).to eq(expected_full_payload) }
    end

    describe 'can view course' do
      Given(:lector_can_view) { true }
      Given(:activities) { ['person:show'] }

      Then { expect(interaction.as_json).to eq(expected_full_payload) }
    end

    describe 'can edit schedule' do
      Given(:schedule_can_edit) { true }
      Given(:activities) { ['class_schedule:edit'] }

      Then { expect(interaction.as_json).to eq(expected_full_payload) }
    end

    describe 'can delete schedule' do
      Given(:schedule_can_delete) { true }
      Given(:activities) { ['class_schedule:destroy'] }

      Then { expect(interaction.as_json).to eq(expected_full_payload) }
    end
  end
end
