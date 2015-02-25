require 'rails_helper'

describe StudyApplicationsController do
  describe 'no user' do
    context 'destroy' do
      Given(:study_application) { double(StudyApplication, person_id: 1, program_id: 1 ) }
      Given(:action) { delete :destroy, id: 1, format: :js }

      Given { allow(study_application).to receive(:class).and_return(StudyApplication) }
      Given { allow(StudyApplication).to receive(:find).with('1').and_return(study_application) }
      Given { expect(study_application).not_to receive(:destroy) }
      Given { expect_any_instance_of(Person).not_to receive(:remove_application_questionnaires) }

      it_behaves_like :not_authenticated_js
    end

    context 'create' do
      Given(:action) { post :create, study_application: { person_id: 1, program_id: 1 }, format: :js }

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
      Given { expect(person).to receive(:remove_application_questionnaires) }

      it_behaves_like :athorized
    end

    shared_examples :athorized_create do
      Given { expect_any_instance_of(StudyApplication).to receive(:save).and_return(true) }
      Given { expect_any_instance_of(StudyApplication).to receive(:person).twice.and_return(person) }
      Given { expect(person).to receive(:add_application_questionnaires) }

      it_behaves_like :athorized
    end

    Given(:person) { double(Person, id: 1, roles: roles) }

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

        When  { delete :destroy, id: 1, format: :js }

        context 'allow own' do
          Given(:study_application) { double(StudyApplication, person_id: person.id, program_id: 1) }

          it_behaves_like :athorized_destroy
        end

        context 'disallow others' do
          Given(:study_application) { double(StudyApplication, person_id: person.id.next, program_id: 1) }

          Given { allow(study_application).to receive(:class).and_return(StudyApplication) }
          Given { expect(study_application).not_to receive(:destroy) }
          Given { expect(person).not_to receive(:remove_application_questionnaires) }

          it_behaves_like :not_athorized
        end
      end

      context 'create' do
        context 'allow own' do
          Given { allow(Person).to receive(:find).with(person.id).and_return(person) }

          When  { post :create, study_application: { person_id: person.id, program_id: 1 }, format: :js }

          it_behaves_like :athorized_create
        end

        context 'disallow others' do
          Given { expect_any_instance_of(StudyApplication).not_to receive(:save) }
          Given { expect(person).not_to receive(:add_application_questionnaires) }

          When  { post :create, study_application: { person_id: person.id.next, program_id: 1 }, format: :js }

          it_behaves_like :not_athorized
        end
      end
    end

    describe 'admin user' do
      Given(:roles) { double('roles', any?: true, name: 'Role') }

      Given { allow(person).to receive(:can_act?).with('study_application:create') { true } }

      context 'destroy' do
        Given { allow(StudyApplication).to receive(:find).with('1').and_return(study_application) }

        Given { allow(roles).to receive_message_chain(:select, :distinct, :map, :flatten) { ['study_application:destroy'] } }

        When  { delete :destroy, id: 1, format: :js }

        context 'allow own' do
          Given(:study_application) { double(StudyApplication, person_id: person.id, program_id: 1 ) }

          it_behaves_like :athorized_destroy
        end

        context 'allow others' do
          Given(:study_application) { double(StudyApplication, person_id: person.id.next, program_id: 1) }

          it_behaves_like :athorized_destroy
        end
      end

      context 'create' do
        Given { allow(roles).to receive_message_chain(:select, :distinct, :map, :flatten) { ['study_application:create'] } }

        context 'allow own' do
          Given { allow(Person).to receive(:find).with(person.id).and_return(person) }

          When  { post :create, study_application: { person_id: person.id, program_id: 1 }, format: :js }

          it_behaves_like :athorized_create
        end

        context 'allow others' do
          Given { allow(Person).to receive(:find).with(person.id.next).and_return(person) }

          When  { post :create, study_application: { person_id: person.id.next, program_id: 1 }, format: :js }

          it_behaves_like :athorized_create
        end
      end
    end
  end
end
