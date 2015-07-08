require 'rails_helper'

describe ClassSchedulesController do
  Given(:params) { { class_schedule: build_stubbed(:class_schedule).attributes.merge(additional_attributes) } }
  Given(:existing_course) { create :course }
  Given(:existing_classroom) { create :classroom }
  Given(:existing_teacher_profile) { create :teacher_profile }
  Given(:existing_academic_group) { create :academic_group }
  Given(:additional_attributes) { { 'id' => nil,
                                    'course_id' => existing_course.id,
                                    'classroom_id' => existing_classroom.id,
                                    'teacher_profile_id' => existing_teacher_profile.id,
                                    'academic_group_ids' => [existing_academic_group.id] } }

  describe 'not signed in' do
    describe 'not_authenticated' do
      context '#index' do
        When { get :index }

        it_behaves_like :not_authenticated
      end

      context '#create' do
        When { post :create, params }

        it_behaves_like :not_authenticated
      end

      context '#new' do
        When { get :new }

        it_behaves_like :not_authenticated
      end

      context '#edit' do
        When { get :edit, id: 1 }

        it_behaves_like :not_authenticated
      end

      context '#update' do
        When { patch :update, id: 1 }

        it_behaves_like :not_authenticated
      end

      context '#destroy' do
        When { delete :destroy, id: 1 }

        it_behaves_like :not_authenticated
      end
    end
  end

  describe 'signed in' do
    Given(:person) { build_stubbed(:person, id: 1) }
    Given(:class_schedule) { build_stubbed(:class_schedule, id: 1) }

    Given { allow(request.env['warden']).to receive(:authenticate!) { person } }
    Given { allow(controller).to receive(:current_person) { person } }
    Given { allow(person).to receive(:class).and_return(Person) }

    describe 'as regular user' do
      Given { allow(ClassSchedule).to receive(:find).with('1').and_return(class_schedule) }

      describe 'not_authorized' do
        context '#index' do
          When { get :index }

          it_behaves_like :not_authorized
        end

        context '#create' do
          When { post :create, params }

          it_behaves_like :not_authorized
        end

        context '#new' do
          When { get :new }

          it_behaves_like :not_authorized
        end

        context '#edit' do
          When { get :edit, id: 1 }

          it_behaves_like :not_authorized
        end

        context '#update' do
          When { patch :update, id: 1 }

          it_behaves_like :not_authorized
        end

        context '#destroy' do
          When { delete :destroy, id: 1 }

          it_behaves_like :not_authorized
        end
      end
    end

    describe 'as admin' do
      Given(:roles) { double('roles', any?: true, title: 'Role') }

      Given { allow(person).to receive(:roles).and_return(roles) }
      Given { allow(roles).to receive_message_chain(:select, :distinct, :map, :flatten) { actions } }

      describe 'DBless tests' do
        Given { allow(ClassSchedule).to receive(:find).with('1').and_return(class_schedule) }

        describe '#index' do
          Given(:class_schedules) { double }
          Given(:actions) { ['class_schedule:index'] }

          Given { allow(ClassSchedule).to receive(:order).and_return(class_schedules) }

          When  { get :index }

          Then { expect(response).to render_template(:index) }
          And  { expect(assigns(:class_schedules)).to eq(class_schedules) }
        end

        describe '#new' do
          Given(:actions) { ['class_schedule:new'] }

          When  { get :new }

          Then  { expect(response).to render_template(:new) }
          And   { expect(assigns(:class_schedule)).to be_a_new(ClassSchedule) }
        end

        describe '#edit' do
          Given(:actions) { ['class_schedule:edit'] }

          When  { get :edit, id: 1 }

          Then  { expect(response).to render_template(:edit) }
          And   { expect(assigns(:class_schedule)).to eq(class_schedule) }
        end
      end

      describe 'DB hit tests' do
        Given { expect(ClassScheduleWithPeople).to receive(:refresh_later) }

        describe '#create' do
          Given(:actions) { ['class_schedule:create'] }

          describe 'with success' do
            Then { expect{post :create, params}.to change(ClassSchedule, :count).by(1) }
            And  { expect(assigns(:class_schedule)).to be_a_kind_of(ClassSchedule) }
            And  { expect(response).to redirect_to(class_schedules_path) }
            And  { is_expected.to set_flash[:notice] }
          end

          describe 'failure' do
            Then { expect { post :create, class_schedule: { course_id: nil } }.not_to change(ClassSchedule, :count) }
            And  { expect(response).to render_template(:new) }
          end
        end

        describe '#update' do
          Given(:actions) { ['class_schedule:update'] }
          Given(:class_schedule) { create :class_schedule }

          When  { patch :update, id: class_schedule.id, class_schedule: class_schedule_params }

          describe 'with success' do
            Given(:new_course) { create :course }
            Given(:class_schedule_params) { { course_id: new_course.id } }

            Then { expect(response).to redirect_to(class_schedules_path) }
            And  { is_expected.to set_flash[:notice] }
            And  { expect(assigns(:class_schedule)).to eq(class_schedule) }
            And  { expect(class_schedule.reload.course_id).to eq(new_course.id) }
          end

          describe 'failure' do
            Given(:class_schedule_params) { { course_id: nil } }

            Then { expect(response).to render_template(:edit) }
            And  { expect(assigns(:class_schedule)).to eq(class_schedule) }
          end
        end

        describe '#destroy' do
          Given(:actions) { ['class_schedule:destroy'] }
          Given!(:class_schedule) { create :class_schedule }

          describe 'with success' do
            Then { expect { delete :destroy, id: class_schedule.id }.to change(ClassSchedule, :count).by(-1) }
            And  { expect(response).to redirect_to(class_schedules_path) }
            And  { is_expected.to set_flash[:notice] }
            And  { expect(assigns(:class_schedule)).to eq(class_schedule) }
          end
        end
      end
    end
  end
end
