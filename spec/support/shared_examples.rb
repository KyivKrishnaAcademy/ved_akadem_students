# views

shared_examples 'academic group new and edit' do
  it { is_expected.to have_title(full_title(title)) }
  it { is_expected.to have_selector('h1', text: h1) }

  describe 'form' do
    let(:form) { 'form.' << action << '_academic_group' }

    it { is_expected.to have_selector(form) }
    it { is_expected.to have_selector("#{form} label", text: 'Group name') }
    it { is_expected.to have_selector("#{form} input#academic_group_group_name") }
    it { is_expected.to have_selector("#{form} select#academic_group_establ_date_1i") }
    it { is_expected.to have_selector("#{form} select#academic_group_establ_date_2i") }
    it { is_expected.to have_selector("#{form} select#academic_group_establ_date_3i") }
    it { is_expected.to have_selector("#{form} label", text: 'Message uk') }
    it { is_expected.to have_selector("#{form} label", text: 'Message ru') }
    it { is_expected.to have_selector("#{form} input#academic_group_group_description") }
    it { is_expected.to have_selector("#{form} input.btn") }
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
    And  { expect(find('body')).to have_selector('h1', text: h1)  }
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
    Given(:get_act) { get action, id: m }
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

  Given(:del_person) { delete 'destroy', id: model.last.id }

  context 'on success' do
    describe 'model count and redirect' do
      Then { expect { del_person }.to change(model, :count).by(-1) }
      And  { expect(del_person).to redirect_to(action: :index)  }
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
  describe "#{subclass}" do
    describe '.filter' do
      it 'returns the cleaned params' do
        expect(
          subclass.filter(
            ActionController::Parameters
              .new(model => { foo: 'foo' }.merge(mod_params))
          )
        ).to eq(mod_params.with_indifferent_access)
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

  When do
    visit method(('' << m_name_underscore << '_path').to_sym).call(
      create m_name_underscore.to_sym
    )
  end

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

shared_examples :invalid_fill_in do |h, model_human|
  describe h[:field] do
    When do
      fill_in h[:field], with: h[:value]
      click_button "Зберегти #{model_human}"
    end

    Then { expect(find('.alert-danger')).to have_content(I18n.t('content.form_has_errors', count: 1)) }
    And  { expect(find('.alert-danger')).to have_selector('ul li', text: /\A#{h[:field]}/) }
  end
end

def underscore_humanize(str)
  str.underscore.humanize
end

shared_examples :valid_select_date do |model_name, field_name, content|
  Given(:year) { model_name == 'Person' ? '1985' : '2010' }

  When do
    select_from = "#{model_name.underscore}[#{field_name}("

    select(year, from: "#{select_from}1i)]")
    select('Травня', from: "#{select_from}2i)]")
    select('27', from: "#{select_from}3i)]")

    click_button "Зберегти #{underscore_humanize(model_name)}"
  end

  Then { expect(find('body')).to have_content("#{content}#{year}-05-27") }

  it_behaves_like :alert_success_updated, underscore_humanize(model_name)
end

shared_examples :valid_select do |model_name, field_name, value, content|
  When do
    select value, from: field_name
    click_button "Зберегти #{underscore_humanize(model_name)}"
  end

  Then { expect(find('body')).to have_content(content) }
  it_behaves_like :alert_success_updated, underscore_humanize(model_name)
end

shared_examples :adds_model do
  Given { @m = model }

  When  { fill_right }

  Then  { expect { click_button 'Створити ' << underscore_humanize(@m.name) }.to change { @m.count }.by(1) }
  And   { expect(page).to have_selector('.alert-success') }
end

shared_examples :not_adds_model do
  before do
    fill_wrong
    @m = model
  end

  it do
    expect { click_button 'Створити ' << underscore_humanize(@m.name) }.not_to change { @m.count }
    expect(page).to have_selector('.alert-danger ul li')
  end
end

shared_examples :link_in_flash do
  before do
    @the_m = fill_right
    @m     = model
  end

  let(:the_m) { @the_m }
  scenario do
    click_button 'Створити ' << underscore_humanize(@m.name)
    href = method(('' << model.name.underscore << '_path').to_sym).call @m.find_by(attr_name => @the_m[attr_name])

    expect(page).to have_link(locator, href: href)
  end
end

shared_examples :allow_with_activities do |activites|
  context "with #{activites.join(' ')}" do
    Given { user.roles << create(:role, activities: activites) }

    context 'allow' do
      Then { is_expected.to permit(user, record) }
    end
  end

  context "without #{activites.join(' ')}" do
    context 'disallow' do
      Then { is_expected.not_to permit(user, record) }
    end
  end
end

shared_examples :study_applications do |admin|
  Given!(:program) { create(:program, title_uk: 'Школа Бхакти', description_uk: 'Описание 1') }
  Given { create(:program, title_uk: 'Бхакти Шастры', description_uk: 'Описание 2') }
  Given { create(:program, title_uk: 'Invisible Program', visible: false) }
  Given { StudyApplication.create(person_id: user.id, program_id: program.id) } if admin

  context 'with application' do
    Given { StudyApplication.create(person_id: person.id, program_id: program.id) }
    Given { person.questionnaires << create(:questionnaire, title_uk: 'Психо тест') }

    describe 'have elements' do
      Then { expect(find('#study_application')).to have_content('Школа Бхакти') }
      And  { expect(find('#study_application')).not_to have_content('Бхакти Шастры') }
      And  { expect(find('#study_application')).to have_link(I18n.t('links.withdraw')) }
      And  { expect(find('#study_application')).to have_css('li', text: 'Заповнити Психо тест') }
      And  { expect(find('#study_application')).to have_css('li', text: 'Додати фотографію до профілю') }
      And  { expect(find('#study_application')).to have_css('li', text: 'Додати паспорт до профілю') }
    end

    describe 'withdraw', :js do
      When { find('.program .btn-danger').click }

      Then { expect(find('#study_application')).to have_selector(:link_or_button, I18n.t('links.apply_to_program')) }
      And  { expect(find('#study_application')).to have_content('Школа Бхакти') }
      And  { expect(find('#study_application')).to have_content('Бхакти Шастры') }
    end
  end

  context 'without application' do
    Given(:programs) { all('#study_application .panel-info') }

    describe 'have elements' do
      Then { expect(programs.first).to have_content('Школа Бхакти') }
      And  { expect(programs.first).to have_content('Описание 1') }
      And  { expect(programs.first).to have_selector(:link_or_button, I18n.t('links.apply_to_program')) }
      And  { expect(programs[1]).to have_content('Бхакти Шастры') }
      And  { expect(programs[1]).to have_content('Описание 2') }
      And  { expect(programs[1]).to have_selector(:link_or_button, I18n.t('links.apply_to_program')) }
      And  { expect(find('#study_application')).not_to have_content('Invisible Program') } unless admin
      And  { expect(find('#study_application')).to have_content('Invisible Program') } if admin
    end

    describe 'apply', :js do
      When { programs.first.find('.btn-success').click }

      Then { expect(find('#study_application')).to have_css('.alert-success .btn-danger[data-method="delete"]') }
      And  { expect(find('#study_application')).to have_content('Школа Бхакти') }
      And  { expect(find('#study_application')).not_to have_content('Бхакти Шастры') }
    end
  end
end

shared_examples :not_authenticated do
  When  { action }

  Then  { expect(response).to redirect_to(new_person_session_path) }
  And   { is_expected.to set_flash[:alert].to(I18n.t('devise.failure.unauthenticated')) }
end

shared_examples :not_authenticated_js do
  When  { action }

  Then { expect(response.status).to eq(401) }
  And  { expect(response.body).to eq(I18n.t('devise.failure.unauthenticated')) }
end

shared_examples :not_authenticated_crud do
  context '#index' do
    Given(:action) { get :index }

    it_behaves_like :not_authenticated
  end

  context '#create' do
    Given(:action) { post :create }

    it_behaves_like :not_authenticated
  end

  context '#new' do
    Given(:action) { get :new }

    it_behaves_like :not_authenticated
  end

  context '#edit' do
    Given(:action) { get :edit, id: 1 }

    it_behaves_like :not_authenticated
  end

  context '#show' do
    Given(:action) { get :show, id: 1 }

    it_behaves_like :not_authenticated
  end

  context '#update' do
    Given(:action) { patch :update, id: 1 }

    it_behaves_like :not_authenticated
  end

  context '#destroy' do
    Given(:action) { delete :destroy, id: 1 }

    it_behaves_like :not_authenticated
  end
end
