require 'rails_helper'

describe 'Study application double submit' do
  Given(:person) { create :person }
  Given(:params_1) { { study_application: { person_id: person.id, program_id: program_1.id }, format: :js } }
  Given(:params_2) { { study_application: { person_id: person.id, program_id: program_2.id }, format: :js } }
  Given(:program_1) { create :program }
  Given(:program_2) { create :program }
  Given(:post_create_1) { post study_applications_path, params: params_1 }
  Given(:post_create_2) { post study_applications_path, params: params_2 }

  When { login_as(person) }

  shared_examples 'create exactly one application' do
    Then { expect { action }.to change { StudyApplication.count }.by(1) }
    And  { expect(response).to have_http_status(:ok) }
    And  { expect(response).to render_template('study_applications/_common') }
  end

  describe 'allow once' do
    Given(:action) { post_create_1 }

    Given { expect_any_instance_of(Person).to receive(:add_application_questionnaires).once }

    include_examples 'create exactly one application'

    describe 'should have right program' do
      When { action }

      Then { expect(StudyApplication.last.program_id).to eq(program_1.id) }
    end
  end

  describe 'disallow twice' do
    Given(:action) do
      post_create_1
      post_create_2
    end

    include_examples 'create exactly one application'

    describe 'should have right program' do
      When { action }

      Then { expect(StudyApplication.last.program_id).to eq(program_2.id) }
    end
  end
end
