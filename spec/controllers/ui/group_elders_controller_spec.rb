require 'rails_helper'

describe Ui::GroupEldersController do
  ACTIONS = %w(group_admins_index group_curators_index group_praepostors_index)

  describe 'not signed in' do
    ACTIONS.each do |action|
      context "##{action}" do
        When { get action, format: :json }

        it_behaves_like :ui_not_authenticated
      end
    end
  end

  describe 'signed in' do
    Given(:person) { build_stubbed(:person, id: 1) }

    Given { allow(request.env['warden']).to receive(:authenticate!) { person } }
    Given { allow(controller).to receive(:current_person) { person } }
    Given { allow(person).to receive(:class).and_return(Person) }

    describe 'as regular user' do
      ACTIONS.each do |action|
        context "##{action}" do
          When { get action, format: :json }

          it_behaves_like :ui_not_authorized
        end
      end
    end

    describe 'as authorized user' do
      Given(:roles) { double('roles', any?: true, title: 'Role') }

      Given { allow(person).to receive(:roles).and_return(roles) }
      Given { allow(roles).to receive_message_chain(:pluck, :flatten) { ['academic_group:edit'] } }

      context '#group_admins_index' do
        Then { expect(GroupAdminsLoadingInteraction).to receive(:new) }
        And  { get :group_admins_index, format: :json }
      end

      context '#group_curators_index' do
        Then { expect(GroupCuratorsLoadingInteraction).to receive(:new) }
        And  { get :group_curators_index, format: :json }
      end

      context '#group_praepostors_index' do
        Then { expect(GroupPraepostorsLoadingInteraction).to receive(:new) }
        And  { get :group_praepostors_index, format: :json }
      end
    end
  end
end
