require 'rails_helper'

describe StudyApplicationsController do
  describe 'no user' do
    shared_examples :not_athorized do
      When { action }

      Then  { expect(response.status).to eq(401) }
      And   { expect(response.body).to eq(I18n.t('devise.failure.unauthenticated')) }
    end

    context 'destroy' do
      Given(:study_application) { double('StudyApplication', person_id: 1, program_id: 1 ) }
      Given(:action) { delete :destroy, id: 1, format: :js }

      Given { allow_any_instance_of(Pundit::PolicyFinder).to receive(:policy).and_return(StudyApplicationPolicy) }
      Given { allow(StudyApplication).to receive(:find).with('1').and_return(study_application) }
      Given { expect(study_application).not_to receive(:destroy) }

      it_behaves_like :not_athorized
    end

    context 'create' do
      Given(:action) { post :create, study_application: { person_id: 1, program_id: 1 }, format: :js }

      Given { expect_any_instance_of(StudyApplication).not_to receive(:save) }

      it_behaves_like :not_athorized
    end
  end

  describe 'regular user' do
    Given(:person) { create :person }

    Given { allow_any_instance_of(Pundit::PolicyFinder).to receive(:policy).and_return(StudyApplicationPolicy) }
    Given { allow(StudyApplication).to receive(:find).with('1').and_return(study_application) }

    When  { sign_in :person, person }
    When  { delete :destroy, id: 1, format: :js }

    context 'destroy' do
      context 'allow own' do
        Given(:study_application) { double('StudyApplication', person_id: person.id, program_id: 1 ) }

        Given { allow(study_application).to receive(:person).and_return(person) }
        Given { expect(person).to receive(:remove_application_questionnaires) }
        Given { expect(study_application).to receive(:destroy) }

        Then  { expect(response.status).to eq(200) }
        And   { expect(response).to render_template(partial: '_common') }
      end

      context 'disallow others' do
        Given(:study_application) { double('StudyApplication', person_id: person.id + 1, program_id: 1 ) }

        Given { expect(study_application).not_to receive(:destroy) }

        Then  { expect(response.status).to eq(302) }
        And   { expect(response).not_to render_template(partial: '_common') }
        And   { is_expected.to set_the_flash[:danger].to(I18n.t(:not_authorized)) }
      end
    end

  end

  describe 'admin user' do
    #Given { @admin = create :person, :admin }
    #
    #When { sign_in :person, @admin }

  end
end
