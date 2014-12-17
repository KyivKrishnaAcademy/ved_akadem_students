require 'rails_helper'

describe 'Show person:' do
  Given { page.set_rack_session(locale: :uk) }

  Given(:person) { create :person }

  When  { login_as_admin }
  When  { visit person_path(person) }

  it_behaves_like :study_applications, true
end
