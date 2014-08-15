require 'spec_helper'

feature 'Delete akadem group:', :js do
  before { login_as_admin }

  it_behaves_like :integration_delete_model, AkademGroup
end
