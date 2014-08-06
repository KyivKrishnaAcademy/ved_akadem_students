require 'spec_helper'

feature 'Delete person:', :js do
  before { login_as_admin }

  it_behaves_like :integration_delete_model, Person
end
