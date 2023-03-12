require 'rails_helper'

describe CoursesController do
  Given(:params) { { course: build_stubbed(:course).attributes } }

  describe 'not signed in' do
    it_behaves_like :failed_auth_crud, :not_authenticated
  end

  describe 'signed in' do
    Given(:person) { build_stubbed(:person, id: 1) }
    Given(:course) { build_stubbed(:course, id: 1) }

    Given { allow(request.env['warden']).to receive(:authenticate!) { person } }
    Given { allow(controller).to receive(:current_person) { person } }
    Given { allow(person).to receive(:class).and_return(Person) }

    describe 'as regular user' do
      Given { allow(Course).to receive(:find).with('1').and_return(course) }

      it_behaves_like :failed_auth_crud, :not_authorized
    end

    describe 'as admin' do
      Given(:roles) { double('roles', title: 'Role') }

      Given { allow(person).to receive(:roles).and_return(roles) }
      Given { allow(roles).to receive(:pluck).with(:activities).and_return(actions) }

      describe 'DBless tests' do
        Given { allow(Course).to receive(:find).with('1').and_return(course) }

        describe '#index' do
          Given(:courses) { double }
          Given(:actions) { ['course:index'] }

          Given { allow(Course).to receive(:order).and_return(courses) }

          When  { get :index }

          Then { expect(response).to render_template(:index) }
          And  { expect(assigns(:courses)).to eq(courses) }
        end

        describe '#new' do
          Given(:actions) { ['course:new'] }

          When  { get :new }

          Then  { expect(response).to render_template(:new) }
          And   { expect(assigns(:course)).to be_a_new(Course) }
        end

        describe '#edit' do
          Given(:actions) { ['course:edit'] }

          When  { get :edit, params: { id: 1 } }

          Then  { expect(response).to render_template(:edit) }
          And   { expect(assigns(:course)).to eq(course) }
        end

        describe '#show' do
          Given(:actions) { ['course:show'] }

          When  { get :show, params: { id: 1 } }

          Then  { expect(response).to render_template(:show) }
          And   { expect(assigns(:course)).to eq(course) }
        end
      end

      describe 'DB hit tests' do
        describe '#create' do
          Given(:actions) { ['course:create'] }

          describe 'with success' do
            Then { expect { post :create, params: params }.to change(Course, :count).by(1) }
            And  { expect(assigns(:course)).to be_a_kind_of(Course) }
            And  { expect(response).to redirect_to(course_path(assigns(:course))) }
            And  { is_expected.to set_flash[:success] }
          end

          describe 'failure' do
            Then { expect { post :create, params: { course: { title: 'John' } } }.not_to change(Course, :count) }
            And  { expect(response).to render_template(:new) }
          end
        end

        describe '#update' do
          Given(:actions) { ['course:update'] }
          Given(:course) { create :course }

          Given { expect(ClassScheduleWithPeople).to receive(:refresh_later) }

          When  { patch :update, params: { id: course.id, course: course_params } }

          describe 'with success' do
            Given(:course_params) { { title: 'Bhakti school', description: 'Awesome' } }

            Then { expect(response).to redirect_to(course_path(course)) }
            And  { is_expected.to set_flash[:success] }
            And  { expect(assigns(:course)).to eq(course) }
          end

          describe 'failure' do
            Given(:course_params) { { title: 'Bhakti school', description: nil } }

            Then { expect(response).to render_template(:edit) }
            And  { expect(assigns(:course)).to eq(course) }
          end
        end

        describe '#destroy' do
          Given(:actions) { ['course:destroy'] }

          Given { expect(ClassScheduleWithPeople).to receive(:refresh_later) }

          describe 'with success' do
            Given!(:course) { create :course }

            Then { expect { delete :destroy, params: { id: course.id } }.to change(Course, :count).by(-1) }
            And  { expect(response).to redirect_to(courses_path) }
            And  { is_expected.to set_flash[:success] }
            And  { expect(assigns(:course)).to eq(course) }
          end

          shared_examples :courses_destroy_prerequisites_are_not_met do
            Then { expect { delete :destroy, params: { id: course.id } }.not_to change(Course, :count) }
            And  { expect(response).to redirect_to(courses_path) }
            And  { is_expected.to set_flash[:danger].to(expected_flash_message) }
            And  { expect(assigns(:course)).to eq(course) }
          end

          describe 'class_schedules_count is not zero' do
            Given!(:course) { create :course, class_schedules_count: 1 }
            Given(:expected_flash_message) do
              I18n.t('courses.destroy.unable_to_destroy') + ' ' + I18n.t(
                'courses.destroy.remove_class_schedules_first',
                class_schedules_count: 1
              )
            end

            it_behaves_like :courses_destroy_prerequisites_are_not_met
          end

          describe 'examination_results_count is not zero' do
            Given!(:course) { create :course, examination_results_count: 2 }
            Given(:expected_flash_message) do
              I18n.t('courses.destroy.unable_to_destroy') + ' ' + I18n.t(
                'courses.destroy.remove_examination_results_first',
                examination_results_count: 2
              )
            end

            it_behaves_like :courses_destroy_prerequisites_are_not_met
          end

          describe 'both class_schedules_count and examination_results_count are not zero' do
            Given!(:course) { create :course, class_schedules_count: 1, examination_results_count: 2 }
            Given(:expected_flash_message) do
              I18n.t('courses.destroy.unable_to_destroy') +
                ' ' +
                I18n.t(
                  'courses.destroy.remove_class_schedules_first',
                  class_schedules_count: 1
                ) +
                ', ' +
                I18n.t(
                  'courses.destroy.remove_examination_results_first',
                  examination_results_count: 2
                )
            end

            it_behaves_like :courses_destroy_prerequisites_are_not_met
          end
        end
      end
    end
  end
end
