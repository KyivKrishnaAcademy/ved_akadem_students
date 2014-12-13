require 'rails_helper'

describe StudyApplicationsController do
  describe 'no user' do
    shared_examples :not_authenticated do
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
      Given { expect_any_instance_of(Person).not_to receive(:remove_application_questionnaires) }

      it_behaves_like :not_authenticated
    end

    context 'create' do
      Given(:action) { post :create, study_application: { person_id: 1, program_id: 1 }, format: :js }

      Given { expect_any_instance_of(StudyApplication).not_to receive(:save) }

      it_behaves_like :not_authenticated
    end
  end

  describe 'regular user' do
    shared_examples :not_athorized do
      Then  { expect(response.status).to eq(302) }
      And   { expect(response).not_to render_template('_common') }
      And   { is_expected.to set_the_flash[:danger].to(I18n.t(:not_authorized)) }
    end

    shared_examples :athorized do
      Then  { expect(response.status).to eq(200) }
      And   { expect(response).to render_template('_common') }
    end

    Given(:person) { create :person }

    When  { sign_in :person, person }

    context 'destroy' do
      Given { allow_any_instance_of(Pundit::PolicyFinder).to receive(:policy).and_return(StudyApplicationPolicy) }
      Given { allow(StudyApplication).to receive(:find).with('1').and_return(study_application) }

      When  { delete :destroy, id: 1, format: :js }

      context 'allow own' do
        Given(:study_application) { double('StudyApplication', person_id: person.id, program_id: 1 ) }

        Given { expect(study_application).to receive(:destroy) }
        Given { allow(study_application).to receive(:person).and_return(person) }
        Given { expect(person).to receive(:remove_application_questionnaires) }

        it_behaves_like :athorized
      end

      context 'disallow others' do
        Given(:study_application) { double('StudyApplication', person_id: person.id + 1, program_id: 1 ) }

        Given { expect(study_application).not_to receive(:destroy) }
        Given { expect(person).not_to receive(:remove_application_questionnaires) }

        it_behaves_like :not_athorized
      end
    end

    context 'create' do
      context 'allow own' do
        Given { expect_any_instance_of(StudyApplication).to receive(:save).and_return(true) }
        Given { expect_any_instance_of(StudyApplication).to receive(:person).and_return(person) }
        Given { expect(person).to receive(:add_application_questionnaires) }

        When  { post :create, study_application: { person_id: person.id, program_id: 1 }, format: :js }

        it_behaves_like :athorized
      end

      context 'disallow others' do
        Given { expect_any_instance_of(StudyApplication).not_to receive(:save) }
        Given { expect(person).not_to receive(:add_application_questionnaires) }

        When  { post :create, study_application: { person_id: person.id + 1, program_id: 1 }, format: :js }

        it_behaves_like :not_athorized
      end
    end
  end

  describe 'admin user' do
    #Given(:admin) { create :person, :admin }
    #
    #When { sign_in :person, admin }

  end
end
