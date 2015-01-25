require 'rails_helper'

describe 'Delete akadem group:', :js do
  Given { page.set_rack_session(locale: :uk) }
  Given { login_as_admin }

  it_behaves_like :integration_delete_model, AkademGroup
end
