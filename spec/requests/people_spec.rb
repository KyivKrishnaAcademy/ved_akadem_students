require 'spec_helper'

describe 'People' do
  When { login_as create(:person, :admin) }

  Given(:new_path)  { new_person_path }
  Given(:edit_path) { edit_person_path(create(:person)) }

  it_behaves_like 'renders _form on New and Edit pages'
end
