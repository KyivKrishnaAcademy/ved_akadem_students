require 'rails_helper'

describe Ui::TeacherProfilesController do
  describe 'not signed in' do
    context '#index' do
      When { get :index, format: :json }

      it_behaves_like :ui_not_authenticated
    end
  end

  describe 'signed in' do
    Given(:person) { build_stubbed(:person, id: 1) }
    Given(:teacher_profile) { build_stubbed(:teacher_profile, id: 1) }

    Given { allow(request.env['warden']).to receive(:authenticate!) { person } }
    Given { allow(controller).to receive(:current_person) { person } }
    Given { allow(person).to receive(:class).and_return(Person) }

    describe 'as regular user' do
      context '#index' do
        When { get :index, format: :json }

        it_behaves_like :ui_not_authorized
      end
    end

    describe 'as authorized user' do
      Given(:roles) { double('roles', any?: true, title: 'Role') }

      Given { allow(person).to receive(:roles).and_return(roles) }
      Given { allow(roles).to receive_message_chain(:pluck, :flatten) { ['course:edit'] } }

      context '#index' do
        Then { expect(TeacherProfilesLoadingInteraction).to receive(:new) }
        And  { get :index, format: :json }
      end
    end
  end
end
