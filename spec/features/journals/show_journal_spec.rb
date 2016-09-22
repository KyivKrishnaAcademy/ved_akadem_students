require 'rails_helper'

describe 'Show journal:' do
  Given(:user) { create(:person, :admin) }

  Given { user.create_student_profile }

  When { login_as(user) }
  When { visit journal_path }

  Then { expect(find('h1')).to have_content(I18n.t('journals.show.journal')) }
end
