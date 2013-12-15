shared_examples "person form" do
  it { should have_selector('label', text: "Name") }
  it { should have_selector('input#person_name') }
  it { should have_selector('input.btn') }
  it { should have_selector('label', text: "Middle name") }
  it { should have_selector('input#person_middle_name') }
  it { should have_selector('label', text: "Surname") }
  it { should have_selector('input#person_surname') }
  it { should have_selector('label', text: "Spiritual name") }
  it { should have_selector('input#person_spiritual_name') }
  it { should have_selector('label', text: "Telephone") }
  it { should have_selector('input#person_telephone') }
  it { should have_selector('label', text: "Email") }
  it { should have_selector('input#person_email') }
  it { should have_selector('label', text: "Gender") }
  it { should have_selector('select#person_gender') }
  it { should have_selector('label', text: "Birthday") }
  it { should have_selector('select#person_birthday_1i') }
  it { should have_selector('select#person_birthday_2i') }
  it { should have_selector('select#person_birthday_3i') }
  it { should have_selector('label', text: "Education and job") }
  it { should have_selector('input#person_edu_and_work') }
  it { should have_selector('label', text: "Emergency contact") }
  it { should have_selector('input#person_emergency_contact') }
  xit { should have_selector('label', text: "Photo") }
  xit { should have_selector('input#person_photo') }
end

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

shared_examples "GET" do |variable, model, action|
  case action
  when :new , :index
    let(:m) { model.all }
    let(:get_act) { get action }
  when :show, :edit
    let(:m) { model.last }
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
  def post_create var
    post :create, var =>
      method(("get_" << var.to_s).to_sym).call.attributes
  end

  context "on success" do
    before(:each) { method(:post_create).call(variable) }

    it { response.should redirect_to(action: :new) }
    it { should set_the_flash[:success]            }
    context "@#{variable.to_s}" do
      subject { assigns(variable) }
      it { should be_a(model)  }
      it { should be_persisted }
    end
  end

  context "on failure" do
    before(:each) do
      model.any_instance.stub(:save).and_return(false)
      method(:post_create).call(variable)
    end

    it { response.should render_template(:new) }
    context "@#{variable.to_s}" do
      it { assigns(variable).should_not be_persisted }
    end
  end
end

shared_examples "DELETE 'destroy'" do |model|
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
