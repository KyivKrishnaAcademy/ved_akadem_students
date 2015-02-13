require 'rails_helper'

describe 'Delete academic group:', :js do
  Given { login_as_admin }

  it_behaves_like :integration_delete_model, AcademicGroup
end
