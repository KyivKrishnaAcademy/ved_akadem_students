require 'rails_helper'

describe StudyApplicationsController do
  describe 'no user' do
    shared_examples :not_athorized do
      When { action }

      Then  { expect(response.status).to eq(401) }
      And   { expect(response.body).to eq(I18n.t('devise.failure.unauthenticated')) }
    end

    context 'destroy' do
      Given { @study_application = double('StudyApplication', person_id: 1, program_id: 1 ) }
      Given { allow_any_instance_of(Pundit::PolicyFinder).to receive(:policy).and_return(StudyApplicationPolicy) }
      Given { allow(StudyApplication).to receive(:find).with('1').and_return(@study_application) }
      Given { expect(@study_application).not_to receive(:destroy) }

      Given(:action) { delete :destroy, id: 1, format: :js }

      it_behaves_like :not_athorized
    end

    context 'create' do
      Given { expect_any_instance_of(StudyApplication).not_to receive(:save) }

      Given(:action) { post :create, study_application: { person_id: 1, program_id: 1 }, format: :js }

      it_behaves_like :not_athorized
    end
  end

  describe 'regular user' do
    #Given { @person = create :person }
    #
    #When { sign_in :person, @person }

  end

  describe 'admin user' do
    #Given { @admin = create :person, :admin }
    #
    #When { sign_in :person, @admin }

  end
end
