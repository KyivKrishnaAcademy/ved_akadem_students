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

shared_examples "CRUD" do
  it { expect(get:    "/#{controller}"         ).to route_to("#{controller}#index"            ) }
  it { expect(post:   "/#{controller}"         ).to route_to("#{controller}#create"           ) }
  it { expect(get:    "/#{controller}/new"     ).to route_to("#{controller}#new"              ) }
  it { expect(get:    "/#{controller}/1/edit"  ).to route_to("#{controller}#edit", id: "1"    ) }
  it { expect(get:    "/#{controller}/1"       ).to route_to("#{controller}#show", id: "1"    ) }
  it { expect(patch:  "/#{controller}/1"       ).to route_to("#{controller}#update", id: "1"  ) }
  it { expect(put:    "/#{controller}/1"       ).to route_to("#{controller}#update", id: "1"  ) }
  it { expect(delete: "/#{controller}/1"       ).to route_to("#{controller}#destroy", id: "1" ) }
end
