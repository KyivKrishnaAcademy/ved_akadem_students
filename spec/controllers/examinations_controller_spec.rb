require 'rails_helper'

describe ExaminationsController do
  Given(:course) { create(:course) }
  Given(:params) { { examination: build_stubbed(:examination).attributes } }
  Given(:nested_route_params) { { course_id: course.id } }

  describe 'not signed in' do
    it_behaves_like :failed_auth_crud, :not_authenticated, %i[index show]
  end

  describe 'signed in' do
    Given(:person) { build_stubbed(:person, id: 1) }
    Given(:examination) { create :examination, course: course }

    Given { allow(request.env['warden']).to receive(:authenticate!) { person } }
    Given { allow(controller).to receive(:current_person) { person } }
    Given { allow(person).to receive(:class).and_return(Person) }

    describe 'as regular user' do
      Given(:default_id) { examination.id }

      it_behaves_like :failed_auth_crud, :not_authorized, %i[index show]
    end

    describe 'as admin' do
      Given(:roles) { double('roles', title: 'Role') }

      Given { allow(person).to receive(:roles).and_return(roles) }
      Given { allow(roles).to receive(:pluck).with(:activities).and_return(actions) }

      describe '#destroy' do
        Given(:actions) { ['examination:destroy'] }

        describe 'with success' do
          Given { examination }

          Then do
            expect do
              delete :destroy, params: nested_route_params.merge({ id: examination.id })
            end.to change(Examination, :count).by(-1)
          end
          And  { expect(response).to redirect_to(course_path(course)) }
          And  { is_expected.to set_flash[:success] }
        end

        describe 'examination_results_count is not zero' do
          Given!(:examination) { create :examination, course: course, examination_results_count: 108 }
          Given(:expected_flash_message) do
            I18n.t(
              'examinations.destroy.remove_examination_results_first',
              examination_results_count: 108
            )
          end

          Then do
            expect do
              delete :destroy, params: nested_route_params.merge({ id: examination.id })
            end.not_to change(Examination, :count)
          end
          And  { expect(response).to redirect_to(course_path(course)) }
          And  { is_expected.to set_flash[:danger].to(expected_flash_message) }
        end
      end
    end
  end
end
