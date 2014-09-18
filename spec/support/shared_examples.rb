# views
shared_examples 'person new and edit' do
  it { expect(subject).to have_title(full_title(title)) }
  it { expect(subject).to have_selector('h1', text: h1) }

  describe 'form' do
    Given(:form) { 'form.' << action << '_person' }

    Then { expect(subject).to have_selector(form) }
    And  { expect(subject).to have_selector("#{form} input#person_name") }
    And  { expect(subject).to have_selector("#{form} input#person_middle_name") }
    And  { expect(subject).to have_selector("#{form} input#person_surname") }
    And  { expect(subject).to have_selector("#{form} input#person_spiritual_name") }
    And  { expect(subject).to have_selector("#{form} input#person_telephones_attributes_0_phone") }
    And  { expect(subject).to have_selector("#{form} input#person_email") }
    And  { expect(subject).to have_selector("#{form} select#person_gender") }
    And  { expect(subject).to have_selector("#{form} #datepicker[name='person[birthday]']") }
    And  { expect(subject).to have_selector("#{form} textarea#person_education") }
    And  { expect(subject).to have_selector("#{form} textarea#person_work") }
    And  { expect(subject).to have_selector("#{form} input#person_emergency_contact") }
    And  { expect(subject).to have_selector("#{form} input#person_photo") }
    And  { expect(subject).to have_selector("#{form} input.btn") }
  end
end

shared_examples 'akadem group new and edit' do
  it { expect(subject).to have_title(full_title(title)) }
  it { expect(subject).to have_selector('h1', text: h1) }

  describe "form" do
    let(:form) { 'form.' << action << '_akadem_group' }

    it { expect(subject).to have_selector(form) }
    it { expect(subject).to have_selector("#{form} label", text: "Group name") }
    it { expect(subject).to have_selector("#{form} input#akadem_group_group_name") }
    it { expect(subject).to have_selector("#{form} label", text: "Establishment date") }
    it { expect(subject).to have_selector("#{form} select#akadem_group_establ_date_1i") }
    it { expect(subject).to have_selector("#{form} select#akadem_group_establ_date_2i") }
    it { expect(subject).to have_selector("#{form} select#akadem_group_establ_date_3i") }
    it { expect(subject).to have_selector("#{form} label", text: "Group description") }
    it { expect(subject).to have_selector("#{form} input#akadem_group_group_description") }
    it { expect(subject).to have_selector("#{form} input.btn") }
  end
end

shared_examples 'index.html' do |headers|
  describe 'title and h1' do
    Then { expect(page).to have_title(full_title(title)) }
    And  { expect(find('body')).to have_selector('h1', text: h1)  }
  end

  describe 'table' do
    Then { expect(find('.table')).to have_selector('tr.' << row_class, count: models_count ) }

    headers.each do |header|
      And { expect(find('.table')).to have_selector('th', text: header) }
    end
  end
end

# routes
shared_examples "CRUD" do |controller|
  it { expect(get:    "/#{controller}"         ).to route_to("#{controller}#index"            ) }
  it { expect(post:   "/#{controller}"         ).to route_to("#{controller}#create"           ) }
  it { expect(get:    "/#{controller}/new"     ).to route_to("#{controller}#new"              ) }
  it { expect(get:    "/#{controller}/1/edit"  ).to route_to("#{controller}#edit", id: "1"    ) }
  it { expect(get:    "/#{controller}/1"       ).to route_to("#{controller}#show", id: "1"    ) }
  it { expect(patch:  "/#{controller}/1"       ).to route_to("#{controller}#update", id: "1"  ) }
  it { expect(put:    "/#{controller}/1"       ).to route_to("#{controller}#update", id: "1"  ) }
  it { expect(delete: "/#{controller}/1"       ).to route_to("#{controller}#destroy", id: "1" ) }
end

# controllers
def create_model(model)
  create model.name.underscore.to_sym
end

shared_examples "GET" do |variable, model, action|
  case action
  when :new, :index
    Given (:m) do
      3.times { create_model model }
      model.all
    end
    Given (:get_act) { get action }
  when :show, :edit
    Given (:m)        { create_model model }
    Given (:get_act)  { get action, id: m }
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
      when :index
        describes = "assigns @#{variable} to be a #{model.name}.all"
      when :show, :edit
        describes = "assigns @#{variable} to be right #{model}"
      end

      describe describes do
        Then { expect(assigns(variable)).to eq(m) }
      end
    end
  end
end

shared_examples "POST 'create'" do |variable, model|
  def post_create(var)
    post :create, var => build(var.to_sym).attributes
  end

  context 'on success' do
    When { post_create variable }

    describe 'redirect and flash' do
      Then { expect(response).to redirect_to(action: :new) }
      And  { expect(subject).to set_the_flash[:success] }
    end

    context "@#{variable.to_s}" do
      subject { assigns(variable) }

      Then { expect(subject).to be_a(model)  }
      Then { expect(subject).to be_persisted }
    end
  end

  context 'on failure' do
    Given { allow_any_instance_of(model).to receive(:save).and_return(false) }

    When  { post_create variable }

    describe 'render' do
      Then { expect(response).to render_template(:new) }
    end

    context "@#{variable.to_s}" do
      Then { expect(assigns(variable)).not_to be_persisted }
    end
  end
end

shared_examples "DELETE 'destroy'" do |model|
  Given { create_model model }

  Given (:del_person) { delete 'destroy', id: model.last.id }

  context 'on success' do
    describe 'model count and redirect' do
      Then { expect{del_person}.to change(model, :count).by(-1) }
      And  { expect(del_person).to redirect_to(action: :index)  }
    end

    describe 'flash' do
      When { del_person }

      Then { expect(subject).to set_the_flash[:success] }
    end
  end

  context 'on failure' do
    Given { allow_any_instance_of(model).to receive_message_chain(:destroy, :destroyed?).and_return(false) }
    Given { request.env['HTTP_REFERER'] = 'where_i_came_from' }

    describe 'model count and redirect' do
      Then { expect{ del_person }.not_to change(model, :count) }
      And  { expect( del_person ).to redirect_to('where_i_came_from') }
    end

    describe 'flash' do
      When { del_person }

      Then { expect(subject).to set_the_flash[:danger] }
    end
  end
end

shared_examples 'controller subclass' do |subclass, model|
  describe "#{subclass}" do
    describe '.filter' do
      it 'returns the cleaned params' do
        expect(
          subclass.filter(
            ActionController::Parameters
              .new(model => { foo: "foo" }.merge(mod_params))
          )
        ).to eq(mod_params.with_indifferent_access)
      end
    end
  end
end

shared_examples "PATCH 'update'" do |model, field|
  Given { create_model model }

  Given (:model_name_underscore)  { model.name.underscore }
  Given (:some_text)              { 'Какой-то текст' }
  Given (:model_last)             { model.last }
  Given (:field)                  { field }
  Given (:model)                  { model }

  def update_model(attribs=nil)
    m         = model_last
    m[field]  = some_text
    attribs ||= m.attributes

    patch :update, {id: m.to_param, model_name_underscore.to_sym => attribs}
  end

  context 'on success' do
    describe "change ##{field}" do
      Then { expect{ update_model }.to change{ model_last[field] }.to(some_text) }
    end

    describe 'receives .update_attributes' do
      Given (:params) { { field.to_s => 'params!' } }

      Then do
        expect_any_instance_of(model).to receive(:update_attributes).with(params)
        update_model(params)
      end
    end

    describe 'flash and redirect' do
      When { update_model }

      Then { expect(subject).to set_the_flash[:success] }
      And  { expect(response).to redirect_to model_last }
    end
  end

  context 'on failure' do
    Given { allow_any_instance_of(model).to receive(:save).and_return(false) }

    When  { update_model }

    Then  { expect(response).to render_template(:edit) }
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
  Given (:m_name_underscore) { model.name.underscore }

  When do
    visit method(('' << m_name_underscore << '_path').to_sym).call(
      create m_name_underscore.to_sym
    )
  end

  describe 'flash' do
    When { click_link 'Delete' }

    Then { expect(page).to have_selector('.alert-success', text: "#{m_name_underscore.humanize.titleize} record deleted!") }
  end

  describe 'model count' do
    Then { expect{ click_link 'Delete' }.to change{model.count}.by(-1) }
  end
end

shared_examples :alert_success_updated do |thing|
  Then { expect(find('body')).to have_selector('.alert-success', text: "#{thing} was successfully updated.") }
end

shared_examples :valid_fill_in do |h, model_human|
  describe h[:field] do
    When do
      fill_in h[:field], with: h[:value]
      click_button "Update #{model_human}"
    end

    Then { expect(find('body')).to have_content(h[:test_field]) }

    it_behaves_like :alert_success_updated, model_human
  end
end

shared_examples :invalid_fill_in do |h, model_human|
  describe h[:field] do
    When do
      fill_in h[:field], with: h[:value]
      click_button "Update #{model_human}"
    end

    Then { expect(find('body')).to have_selector('#error_explanation .alert-danger', text: 'The form contains 1 error.') }
    And  { expect(find('body')).to have_selector('#error_explanation ul li', text: /\A#{h[:field]}/) }
  end
end

def underscore_humanize(str)
  str.underscore.humanize
end

shared_examples :valid_select_date do |model_name, field_name, content|
  Given (:year) { model_name == 'Person' ? '1985' : '2010' }

  When do
    select_from = "#{model_name.underscore}[#{field_name}("
    select year  , from: "#{select_from}1i)]"
    select 'May' , from: "#{select_from}2i)]"
    select '27'  , from: "#{select_from}3i)]"
    click_button "Update #{underscore_humanize(model_name)}"
  end

  Then { expect(find('body')).to have_content("#{content}#{year}-05-27") }

  it_behaves_like :alert_success_updated, underscore_humanize(model_name)
end

shared_examples :valid_select do |model_name, field_name, value, content|
  When do
    select value, from: field_name
    click_button "Update #{underscore_humanize(model_name)}"
  end

  Then { expect(find('body')).to have_content(content) }
  it_behaves_like :alert_success_updated, underscore_humanize(model_name)
end

shared_examples :adds_model do
  before do
    fill_right
    @m = model
  end

  scenario do
    expect { click_button 'Create ' << underscore_humanize(@m.name) }.to change{@m.count}.by(1)
    expect(page).to have_selector('.alert-success')
  end
end

shared_examples :not_adds_model do
  before do
    fill_wrong
    @m = model
  end

  it do
    expect { click_button 'Create ' << underscore_humanize(@m.name) }.not_to change{@m.count}
    expect(page).to have_selector('section#error_explanation')
  end
end

shared_examples :link_in_flash do
  before do
    @the_m = fill_right
    @m     = model
  end

  let(:the_m) { @the_m }
  scenario do
    click_button "Create " << underscore_humanize(@m.name)
    href = method(('' << model.name.underscore << '_path').to_sym).call @m.find_by(attr_name => @the_m[attr_name])

    expect(page).to have_link(locator, href: href)
  end
end

shared_examples :allow_with_activities do |activites|
  context "with #{activites.join(' ')}" do
    Given { user.roles << create(:role, activities: activites) }

    context 'allow' do
      Then { expect(subject).to permit(user, record) }
    end
  end

  context "without #{activites.join(' ')}" do
    context 'disallow' do
      Then { expect(subject).not_to permit(user, record) }
    end
  end
end
