require 'rails_helper'

describe PdfExportsController do
  %i(group_list attendance_template).each do |described_action|
    describe 'not signed in' do
      describe 'not_authenticated' do
        context "##{described_action}" do
          When { get described_action, params: { id: 1, format: :pdf } }

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
          context "##{described_action}" do
            When { get described_action, params: { id: 1, format: :pdf } }

            it_behaves_like :not_authorized
          end
        end
      end

      describe 'as admin' do
        Given(:roles) { double('roles', title: 'Role') }

        Given { allow(person).to receive(:roles).and_return(roles) }
        Given { allow(roles).to receive(:pluck).with(:activities).and_return(actions) }

        describe "##{described_action}" do
          Given(:actions) { ["academic_group:#{described_action}_pdf", 'academic_group:show'] }

          When { get described_action, params: { id: 1, format: :pdf } }

          Then { expect(response).to be_ok }
        end
      end
    end
  end
end
