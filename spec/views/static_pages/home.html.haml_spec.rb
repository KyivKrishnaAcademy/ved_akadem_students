require 'rails_helper'

describe 'static_pages/home' do
  Given(:ag_name) { 'ТВ99-1' }
  Given(:group) { create :akadem_group, { group_name: ag_name } }
  Given(:user) { create :person }

  Given { assign(:person_decorator, PersonDecorator.new(user)) }
  Given { assign(:programs, Program.where(visible: true)) }
  Given { assign(:study_application, StudyApplication.new) }
  Given { allow(view).to receive(:current_person).and_return(user) }

  When  { render }

  describe 'user is a student' do
    Given { user.create_student_profile.move_to_group(group) }

    Then  { expect(rendered).to have_link(ag_name) }
  end

  describe 'user is not a student' do
    Then  { expect(rendered).not_to have_link(ag_name) }
  end
end
