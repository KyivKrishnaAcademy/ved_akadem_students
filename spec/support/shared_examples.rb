# views
shared_examples "person new and edit" do
  it { should have_title(full_title(title)) }
  it { should have_selector('h1', text: h1) }

  describe "from" do
    let(:form) { 'form.' << action << '_person' }

    it { should have_selector(form) }
    it { should have_selector("#{form} label", text: "Name") }
    it { should have_selector("#{form} input#person_name") }
    it { should have_selector("#{form} label", text: "Middle name") }
    it { should have_selector("#{form} input#person_middle_name") }
    it { should have_selector("#{form} label", text: "Surname") }
    it { should have_selector("#{form} input#person_surname") }
    it { should have_selector("#{form} label", text: "Spiritual name") }
    it { should have_selector("#{form} input#person_spiritual_name") }
    it { should have_selector("#{form} label", text: "Telephone") }
    it { should have_selector("#{form} input#person_telephone") }
    it { should have_selector("#{form} label", text: "Email") }
    it { should have_selector("#{form} input#person_email") }
    it { should have_selector("#{form} label", text: "Gender") }
    it { should have_selector("#{form} select#person_gender") }
    it { should have_selector("#{form} label", text: "Birthday") }
    it { should have_selector("#{form} select#person_birthday_1i") }
    it { should have_selector("#{form} select#person_birthday_2i") }
    it { should have_selector("#{form} select#person_birthday_3i") }
    it { should have_selector("#{form} label", text: "Education and job") }
    it { should have_selector("#{form} input#person_edu_and_work") }
    it { should have_selector("#{form} label", text: "Emergency contact") }
    it { should have_selector("#{form} input#person_emergency_contact") }
    xit { should have_selector("#{form} label", text: "Photo") }
    xit { should have_selector("#{form} input#person_photo") }
    it { should have_selector("#{form} input.btn") }
  end
end

shared_examples "akadem group new and edit" do
  it { should have_title(full_title(title)) }
  it { should have_selector('h1', text: h1) }

  describe "form" do
    let(:form) { 'form.' << action << '_akadem_group' }

    it { should have_selector(form) }
    it { should have_selector("#{form} label", text: "Group name") }
    it { should have_selector("#{form} input#akadem_group_group_name") }
    it { should have_selector("#{form} label", text: "Establishment date") }
    it { should have_selector("#{form} select#akadem_group_establ_date_1i") }
    it { should have_selector("#{form} select#akadem_group_establ_date_2i") }
    it { should have_selector("#{form} select#akadem_group_establ_date_3i") }
    it { should have_selector("#{form} label", text: "Group description") }
    it { should have_selector("#{form} input#akadem_group_group_description") }
    it { should have_selector("#{form} input.btn") }
  end
end

shared_examples 'index.html' do |headers|
  Then { page.should have_title(full_title(title)) }
  Then { find('body').should have_selector('h1', text: h1)  }

  describe 'table' do
    headers.each do |header|
      Then { find('.table').should have_selector('th', text: header) }
    end

    Then { find('.table').should have_selector('tr.' << row_class, count: models_count + 1) }
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
  when :new , :index
    let(:m) do
      3.times { create_model model }
      model.all
    end
    let(:get_act) { get action }
  when :show, :edit
    let(:m) { create_model model }
    let(:get_act) { get action, id: m }
  end

  before(:each) { get_act }

  context ":#{action}" do
    it { response.should be_success }
    case action
    when :new
      it "assigns @#{variable} a new #{model} model" do
        assigns(variable).should be_a_new(model)
      end
    else
      case action
      when :index
        describes = "assigns @#{variable} to be a #{model.name}.all"
      when :show, :edit
        describes = "assigns @#{variable} to be right #{model}"
      end
      it describes do
        assigns(variable).should eq(m)
      end
    end
  end
end

shared_examples "POST 'create'" do |variable, model|
  def post_create(var)
    post :create, var => build(var.to_sym).attributes
  end

  context 'on success' do
    before(:each) { post_create variable }

    it { response.should redirect_to(action: :new) }
    it { should set_the_flash[:success] }

    context "@#{variable.to_s}" do
      subject { assigns(variable) }

      it { should be_a(model)  }
      it { should be_persisted }
    end
  end

  context 'on failure' do
    before(:each) do
      model.any_instance.stub(:save).and_return(false)
      post_create variable
    end

    it { response.should render_template(:new) }
    context "@#{variable.to_s}" do
      it { assigns(variable).should_not be_persisted }
    end
  end
end

shared_examples "DELETE 'destroy'" do |model|
  before { create_model model }

  let(:del_person) { delete 'destroy', id: model.last.id }

  context "on success" do
    it { expect{ del_person }.to change(model, :count).by(-1) }
    it { expect( del_person ).to redirect_to(action: :index)  }
    it { del_person; should set_the_flash[:success]           }
  end

  context "on failure" do
    before(:each) do
      model.any_instance.stub_chain(:destroy, :destroyed?).and_return(false)
      request.env["HTTP_REFERER"] = "where_i_came_from"
    end

    it { expect{ del_person }.not_to change(model, :count)        }
    it { expect( del_person ).to redirect_to("where_i_came_from") }
    it { del_person; should set_the_flash[:error]                 }
  end
end

shared_examples "controller subclass" do |subclass, model|
  describe "#{subclass}" do
    describe ".filter" do
      it "returns the cleaned params" do
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
  before(:each) { create_model model }

  let(:model_name_underscore) { model.name.underscore }
  let(:some_text) { 'Какой-то текст' }
  let(:model_last) { model.last }
  let(:field) { field }
  let(:model) { model }

  def update_model(attribs=nil)
    m         = model_last
    m[field]  = some_text
    attribs ||= m.attributes
    patch :update, {id: m.to_param, model_name_underscore.to_sym => attribs}
  end

  context 'on success' do
    it { expect{ update_model }.to change{ model_last[field] }.to(some_text) }

    it 'receives .update_attributes' do
      h = {field.to_s => 'params'}
      model.any_instance.should_receive(:update_attributes).with(h)
      update_model(h)
    end

    # don't use context before(:each) { update_model } because spec doc formating
    it { update_model; should set_the_flash[:success] }
    it { update_model; response.should redirect_to model_last }
  end

  context 'on failure' do
    before do
      model.any_instance.stub(:save).and_return(false)
      update_model
    end

    it { response.should render_template(:edit)}
  end
end

# requests
shared_examples "renders _form" do
  it { response.should render_template(partial: '_form') }
end

shared_examples "renders _form on New and Edit pages" do
  describe "New page" do
    before { get new_path }
    it_behaves_like "renders _form"
  end

  describe "Edit page" do
    before { get edit_path }
    it_behaves_like "renders _form"
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

  Then do
    click_link 'Delete'
    page.should have_selector('section.alert-success', text: "#{m_name_underscore.humanize.titleize} record deleted!")
  end

  Then { expect{ click_link 'Delete' }.to change{model.count}.by(-1) }
end

shared_examples :alert_success_updated do |thing|
  Then { find('body').should have_selector('.alert-success', text: "#{thing} was successfully updated.") }
end

shared_examples :valid_fill_in do |h, model_human|
  describe h[:field] do
    When do
      fill_in h[:field], with: h[:value]
      click_button "Update #{model_human}"
    end

    Then { find('body').should have_content(h[:test_field]) }

    it_behaves_like :alert_success_updated, model_human
  end
end

shared_examples :invalid_fill_in do |h, model_human|
  describe h[:field] do
    When do
      fill_in h[:field], with: h[:value]
      click_button "Update #{model_human}"
    end

    Then { find('body').should have_selector('#error_explanation .alert-danger', text: 'The form contains 1 error.') }
    Then { find('body').should have_selector('#error_explanation ul li', text: /\A#{h[:field]}/) }
  end
end

def underscore_humanize str
  str.underscore.humanize
end

shared_examples :valid_select_date do |model_name, field_name, content|
  When do
    select_from = "#{model_name.underscore}[#{field_name}("
    select '2010', from: "#{select_from}1i)]"
    select 'May' , from: "#{select_from}2i)]"
    select '27'  , from: "#{select_from}3i)]"
    click_button "Update #{underscore_humanize(model_name)}"
  end

  Then { find('body').should have_content("#{content}2010-05-27") }
  it_behaves_like :alert_success_updated, underscore_humanize(model_name)
end

shared_examples :valid_select do |model_name, field_name, value, content|
  When do
    select value, from: field_name
    click_button "Update #{underscore_humanize(model_name)}"
  end

  Then { find('body').should have_content(content) }
  it_behaves_like :alert_success_updated, underscore_humanize(model_name)
end

shared_examples :adds_model do
  before do
    fill_right
    @m = model
  end

  scenario do
    expect { click_button "Create " << underscore_humanize(@m.name) }.to change{@m.count}.by(1)
    expect(page).to have_selector('section.alert-success')
  end
end

shared_examples :not_adds_model do
  before do
    fill_wrong
    @m = model
  end

  scenario do
    expect { click_button "Create " << underscore_humanize(@m.name) }.not_to change{@m.count}.by(1)
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

    page.should have_link(locator, href: href)
  end
end

shared_examples :allow_with_activities do |activites|
  context "#{activites.join(' ')}" do
    before { user.roles << create(:role, activities: activites) }

    it 'allow' do
      should permit(user, record)
    end
  end

  context 'without activities' do
    it 'disallow' do
      should_not permit(user, record)
    end
  end
end
