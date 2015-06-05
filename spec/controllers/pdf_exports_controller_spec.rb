require 'rails_helper'

describe PdfExportsController do
  describe 'not signed in' do
    describe 'not_authenticated' do
      context '#group_list' do
        When { get :group_list, id: 1, format: :pdf }

        Then { expect(response.status).to eq(401) }
        And  { expect(response.body).to eq(I18n.t('devise.failure.unauthenticated')) }
      end
    end
  end

  describe 'signed in' do
    Given(:person) { build_stubbed(:person, id: 1) }
    Given(:academic_group) { build_stubbed(:academic_group, id: 1) }

    Given { allow(request.env['warden']).to receive(:authenticate!) { person } }
    Given { allow(controller).to receive(:current_person) { person } }
    Given { allow(person).to receive(:class).and_return(Person) }

    Given { allow(AcademicGroup).to receive(:find).with('1').and_return(academic_group) }

    describe 'as regular user' do
      describe 'not_authorized' do
        context '#group_list' do
          When { get :group_list, id: 1, format: :pdf }

          it_behaves_like :not_authorized
        end
      end
    end

    describe 'as admin' do
      Given(:roles) { double('roles', any?: true, title: 'Role') }

      Given { allow(person).to receive(:roles).and_return(roles) }
      Given { allow(roles).to receive_message_chain(:select, :distinct, :map, :flatten) { actions } }

      describe '#group_list' do
        Given(:actions) { ['academic_group:group_list_pdf'] }

        When { get :group_list, id: 1, format: :pdf }

        Then { expect(response).to be_ok }
      end
    end
  end
end
