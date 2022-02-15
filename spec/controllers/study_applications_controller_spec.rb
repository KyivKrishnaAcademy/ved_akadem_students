require 'rails_helper'

describe StudyApplicationsController do
  describe 'no user' do
    context 'destroy' do
      Given(:study_application) { double(StudyApplication, person_id: 1, program_id: 1) }
      Given(:action) { delete :destroy, params: { id: 1, format: :js } }

      Given { allow(study_application).to receive(:class).and_return(StudyApplication) }
      Given { allow(StudyApplication).to receive(:find).with('1').and_return(study_application) }
      Given { expect(study_application).not_to receive(:destroy) }

      it_behaves_like :not_authenticated_js
    end

    context 'create' do
      Given(:action) { post :create, params: { study_application: { person_id: 1, program_id: 1 }, format: :js } }

      Given { expect_any_instance_of(StudyApplication).not_to receive(:save) }

      it_behaves_like :not_authenticated_js
    end
  end

  describe 'with user' do
    shared_examples :athorized do
      Then  { expect(response.status).to eq(200) }
      And   { expect(response).to render_template('_common') }
    end

    shared_examples :athorized_destroy do
      Given { allow(study_application).to receive(:class).and_return(StudyApplication) }
      Given { expect(study_application).to receive_message_chain(:destroy, :destroyed?).and_return(true) }
      Given { allow(study_application).to receive(:person).and_return(person) }

      it_behaves_like :athorized
    end

    shared_examples :athorized_create do
      Given(:mailer) { double }

      Given { expect_any_instance_of(StudyApplication).to receive(:save).and_return(true) }
      Given { expect_any_instance_of(StudyApplication).to receive(:person).exactly(3).and_return(person) }
      Given { expect(person).to receive(:add_application_questionnaires) }
      Given { expect(ProgrammApplicationsMailer).to receive(:submitted).and_return(mailer) }
      Given { expect(mailer).to receive(:deliver_later) }

      it_behaves_like :athorized
    end

    Given(:person) { double(Person, id: 1, roles: roles, locale: :uk) }

    Given { allow(person).to receive(:is_a?).and_return(false) }
    Given { allow(person).to receive(:is_a?).with(Person).and_return(true) }
    Given { allow(person).to receive(:reload).and_return(person) }
    Given { allow(request.env['warden']).to receive(:authenticate!) { person } }
    Given { allow(controller).to receive(:current_person) { person } }

    describe 'regular user' do
      shared_examples :not_athorized do
        Then  { expect(response.status).to eq(303) }
        And   { expect(response).not_to render_template('_common') }
        And   { is_expected.to set_flash[:danger].to(I18n.t(:not_authorized)) }
      end

      Given(:roles) { [] }

      Given { allow(person).to receive(:can_act?).with('study_application:create') { false } }

      context 'destroy' do
        Given { allow(StudyApplication).to receive(:find).with('1').and_return(study_application) }

        When  { delete :destroy, params: { id: 1, format: :js, study_application: { is_links_in_pending_docs: true } } }

        context 'allow own' do
          Given(:study_application) { double(StudyApplication, person_id: person.id, program_id: 1) }

          it_behaves_like :athorized_destroy
        end

        context 'disallow others' do
          Given(:study_application) { double(StudyApplication, person_id: person.id.next, program_id: 1) }

          Given { allow(study_application).to receive(:class).and_return(StudyApplication) }
          Given { expect(study_application).not_to receive(:destroy) }

          it_behaves_like :not_athorized
        end
      end

      context 'create' do
        When  { post :create, params: params }

        context 'allow own' do
          Given(:params) { { study_application: { person_id: person.id, program_id: 1 }, format: :js } }

          Given { allow(Person).to receive(:find).with(person.id).and_return(person) }

          it_behaves_like :athorized_create
        end

        context 'disallow others' do
          Given(:params) { { study_application: { person_id: person.id.next, program_id: 1 }, format: :js } }

          Given { expect_any_instance_of(StudyApplication).not_to receive(:save) }
          Given { expect(person).not_to receive(:add_application_questionnaires) }

          it_behaves_like :not_athorized
        end
      end
    end

    describe 'admin user' do
      Given(:roles) { double('roles', any?: true, name: 'Role') }

      Given { allow(person).to receive(:can_act?).with('study_application:create') { true } }

      context 'destroy' do
        Given { allow(StudyApplication).to receive(:find).with('1').and_return(study_application) }

        Given do
          allow(roles).to receive_message_chain(:select, :distinct, :map, :flatten) { ['study_application:destroy'] }
        end

        When { delete :destroy, params: { id: 1, format: :js, study_application: { is_links_in_pending_docs: true } } }

        context 'allow own' do
          Given(:study_application) { double(StudyApplication, person_id: person.id, program_id: 1) }

          it_behaves_like :athorized_destroy
        end

        context 'allow others' do
          Given(:study_application) { double(StudyApplication, person_id: person.id.next, program_id: 1) }

          it_behaves_like :athorized_destroy
        end
      end

      context 'create' do
        Given do
          allow(roles).to receive_message_chain(:select, :distinct, :map, :flatten) { ['study_application:create'] }
        end

        When { post :create, params: params, format: :js }

        context 'allow own' do
          Given(:params) { { study_application: { person_id: person.id, program_id: 1 } } }

          Given { allow(Person).to receive(:find).with(person.id).and_return(person) }

          it_behaves_like :athorized_create
        end

        context 'allow others' do
          Given(:params) { { study_application: { person_id: person.id.next, program_id: 1 } } }

          Given { allow(Person).to receive(:find).with(person.id.next).and_return(person) }

          it_behaves_like :athorized_create
        end
      end
    end
  end
end
