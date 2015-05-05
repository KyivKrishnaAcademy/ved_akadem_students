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
      Given(:roles) { double('roles', any?: true, name: 'Role') }

      Given { allow(person).to receive(:roles).and_return(roles) }
      Given { allow(roles).to receive_message_chain(:select, :distinct, :map, :flatten) { actions } }

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

          When  { get :edit, id: 1 }

          Then  { expect(response).to render_template(:edit) }
          And   { expect(assigns(:course)).to eq(course) }
        end

        describe '#show' do
          Given(:actions) { ['course:show'] }

          When  { get :show, id: 1 }

          Then  { expect(response).to render_template(:show) }
          And   { expect(assigns(:course)).to eq(course) }
        end
      end

      describe 'DB hit tests' do
        describe '#create' do
          Given(:actions) { ['course:create'] }

          describe 'with success' do
            Then { expect { post :create, params }.to change(Course, :count).by(1) }
            And  { expect(assigns(:course)).to be_a_kind_of(Course) }
            And  { expect(response).to redirect_to(course_path(assigns(:course))) }
            And  { is_expected.to set_flash[:notice] }
          end

          describe 'failure' do
            Then { expect { post :create, course: { name: 'John' } }.not_to change(Course, :count) }
            And  { expect(response).to render_template(:new) }
          end
        end

        describe '#update' do
          Given(:actions) { ['course:update'] }
          Given(:course) { create :course }

          When  { patch :update, id: course.id, course: course_params }

          describe 'with success' do
            Given(:course_params) { { name: 'Bhakti school', description: 'Awesome' } }

            Then { expect(response).to redirect_to(course_path(course)) }
            And  { is_expected.to set_flash[:notice] }
            And  { expect(assigns(:course)).to eq(course) }
          end

          describe 'failure' do
            Given(:course_params) { { name: 'Bhakti school', description: nil } }

            Then { expect(response).to render_template(:edit) }
            And  { expect(assigns(:course)).to eq(course) }
          end
        end

        describe '#destroy' do
          Given(:actions) { ['course:destroy'] }
          Given!(:course) { create :course }

          describe 'with success' do
            Then { expect { delete :destroy, id: course.id }.to change(Course, :count).by(-1) }
            And  { expect(response).to redirect_to(courses_path) }
            And  { is_expected.to set_flash[:notice] }
            And  { expect(assigns(:course)).to eq(course) }
          end
        end
      end
    end
  end
end
