# require 'rails_helper'

describe 'Delete person:', :js do
  Given { login_as_admin }

  it_behaves_like :integration_delete_model, Person
end
