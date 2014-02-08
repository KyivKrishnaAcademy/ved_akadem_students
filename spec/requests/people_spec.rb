require 'spec_helper'
include Warden::Test::Helpers
Warden.test_mode!

describe "People" do
  before { login_as create_person }

  it_behaves_like "renders _form on New and Edit pages" do
    let(:new_path) { new_person_path }
    let(:edit_path) { edit_person_path(create_person) }
  end
end
