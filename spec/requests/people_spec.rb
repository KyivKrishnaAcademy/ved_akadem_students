require 'spec_helper'

describe "People" do
  after(:all) { Person.destroy_all }

  it_behaves_like "renders _form on New and Edit pages" do
    let(:new_path) { new_person_path }
    let(:edit_path) { edit_person_path(create_person) }
  end
end
