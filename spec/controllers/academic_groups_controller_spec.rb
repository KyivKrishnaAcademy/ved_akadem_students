require 'rails_helper'

describe AcademicGroupsController do
  Given(:mod_params) do
    {
      title:              'ШБ13-5',
      establ_date:        3600.days.ago.to_date.to_s,
      group_description:  'Харе Кришна Харе Кришна Кришна Кришна Харе Харе'
    }
  end

  describe 'params' do
    it_behaves_like :controller_params_subclass, AcademicGroupsController::AcademicGroupParams, :academic_group
  end

  shared_examples :academic_groups_actions do |*activities|
    context 'signed in' do
      When { sign_in user }
      When { action }

      describe 'should allow' do
        if activities.include?('academic_group:update')
          Given { expect(ClassScheduleWithPeople).to receive(:refresh_later) }
        end

        Given(:user) { create :person, roles: [create(:role, activities: activities.flatten)] }

        Then { expectation }
      end

      describe 'should not allow with other activities' do
        Given(:user) { create :person, roles: [create(:role, activities: (all_activities - activities.flatten))] }

        Then  { is_expected.to set_flash[:danger].to(I18n.t('not_authorized')) }
        And   { expect(response).to redirect_to(root_path) }
      end
    end

    context 'not signed in' do
      When { action }

      Then { expect(response).to redirect_to(new_person_session_path) }
      And  { is_expected.to set_flash[:alert].to(I18n.t('devise.failure.unauthenticated')) }
    end
  end

  context 'post: :create with ["academic_group:create"]' do
    Given(:action) do
      post(
        :create,
        params: {
          academic_group: {
            administrator_id: create(:person).id,
            title: 'ШБ00-1',
            group_description: 'aaaaaaaaaa',
            establ_date: Time.zone.now
          }
        }
      )
    end

    Given(:expectation) do
      expect(response).to redirect_to(action: :new)
      is_expected.to set_flash[:success]
      expect(assigns(:academic_group)).to be_a(AcademicGroup)
      expect(assigns(:academic_group)).to be_persisted
    end

    it_behaves_like :academic_groups_actions, 'academic_group:create'

    describe 'on failure with valid rights' do
      Given { allow_any_instance_of(AcademicGroup).to receive(:save).and_return(false) }

      When  { sign_in create(:person, roles: [create(:role, activities: %w(academic_group:create))]) }
      When  { action }

      Then  { expect(response).to render_template(:new) }
      And   { expect(assigns(:academic_group)).not_to be_persisted }
    end
  end

  context 'get: :index with ["academic_group:index"]' do
    Given { allow(AcademicGroup).to receive_message_chain(:all, :by_active_title).and_return('some records') }

    Given(:action)      { get :index }
    Given(:expectation) do
      expect(response).to render_template(:index)
      expect(assigns(:academic_groups)).to eq('some records')
    end

    it_behaves_like :academic_groups_actions, 'academic_group:index'
  end

  context 'get: :new with ["academic_group:new"]' do
    Given(:action)      { get :new }
    Given(:expectation) do
      expect(response).to render_template(:new)
      expect(assigns(:academic_group)).to be_a_new(AcademicGroup)
    end

    it_behaves_like :academic_groups_actions, 'academic_group:new'
  end

  context 'get: :show with ["academic_group:show"]' do
    Given(:action) { get :show, params: { id: group.id } }
    Given(:expectation) do
      expect(response).to render_template(:show)
      expect(assigns(:academic_group)).to eq(group)
    end

    describe 'DB hit tests' do
      Given(:group) { create :academic_group }

      it_behaves_like :academic_groups_actions, 'academic_group:show'
    end

    describe 'DBless tests' do
      Given(:person) { double(Person, id: 1, roles: [], locale: :uk, short_name: 'Adi das') }
      Given(:groups) { double }
      Given(:people) { double }
      Given(:group)  { double(AcademicGroup, id: 1) }

      Given { allow(request.env['warden']).to receive(:authenticate!) { person } }
      Given { allow(controller).to receive(:current_person) { person } }

      Given { allow(group).to receive(:class).and_return(AcademicGroup) }
      Given { allow(group).to receive(:examinations).and_return(Examination.none) }
      Given { allow(group).to receive(:active_students).and_return(people) }
      Given { allow(people).to receive(:joins).and_return(Person.none) }
      Given { allow(people).to receive(:includes).and_return(Person.none) }
      Given { allow_any_instance_of(AcademicGroupPolicy::Scope).to receive(:resolve).and_return(groups) }
      Given { allow(groups).to receive(:find).with('1').and_return(group) }

      context 'user is student of the group' do
        Given(:people) { [person] }
        Given(:student_profile) { double(StudentProfile) }

        Given { allow(group).to receive(:active_students).and_return(people) }
        Given { allow(people).to receive(:includes).and_return(people) }
        Given { allow(person).to receive_message_chain(:photo, :versions).and_return(nil) }
        Given { allow(person).to receive_message_chain(:student_profile, :id).and_return(1) }

        When { action }

        Then { expectation }
      end

      describe 'curator and administrator' do
        Given { allow_any_instance_of(AcademicGroupPolicy).to receive(:student_of_the_group?).and_return(false) }

        context 'user is curator of the group' do
          Given { allow(group).to receive(:curator_id).and_return(1) }

          When { action }

          Then { expectation }
        end

        context 'user is administrator of the group' do
          Given { allow(group).to receive(:curator_id).and_return(2) }
          Given { allow(group).to receive(:administrator_id).and_return(1) }

          When { action }

          Then { expectation }
        end
      end
    end
  end

  context 'get: :edit with ["academic_group:edit"]' do
    Given(:record) { create :academic_group }

    Given(:action)      { get :edit, params: { id: record.id } }
    Given(:expectation) do
      expect(response).to render_template(:edit)
      expect(assigns(:academic_group)).to eq(record)
    end

    it_behaves_like :academic_groups_actions, 'academic_group:edit'
  end

  context 'patch: :update with ["academic_group:update"]' do
    Given(:record) { create :academic_group }
    Given(:action) { patch :update, params: { id: record.id, academic_group: mod_params } }

    Given(:expectation) do
      expect(response).to redirect_to(record)
      expect(assigns(:academic_group)).to eq(record)
      is_expected.to set_flash[:success]
    end

    it_behaves_like :academic_groups_actions, 'academic_group:update'

    describe 'other' do
      Given { expect(ClassScheduleWithPeople).to receive(:refresh_later) }

      When { sign_in create(:person, roles: [create(:role, activities: %w(academic_group:update))]) }

      describe 'record receives update' do
        Then do
          expect_any_instance_of(AcademicGroup)
            .to receive(:update).with(ActionController::Parameters.new(mod_params).permit!)
          action
        end
      end

      describe 'on failure with valid rights' do
        Given { allow_any_instance_of(AcademicGroup).to receive(:save).and_return(false) }

        When  { action }

        Then  { expect(response.status).to render_template(:edit) }
      end
    end
  end

  context 'delete: :destroy with ["academic_group:destroy"]' do
    Given!(:record) { create :academic_group }

    Given(:action) { delete :destroy, params: { id: record.id } }

    context 'signed in' do
      Given { expect(ClassScheduleWithPeople).to receive(:refresh_later) }

      Given(:user) { create :person, roles: [create(:role, activities: %w(academic_group:destroy))] }

      When { sign_in user }

      context 'on success' do
        Then { expect { action }.to change(AcademicGroup, :count).by(-1) }
        And  { expect(action).to redirect_to(action: :index) }
        And  { is_expected.to set_flash[:success] }
      end

      context 'on failure' do
        Given { allow_any_instance_of(AcademicGroup).to receive_message_chain(:destroy, :destroyed?).and_return(false) }
        Given { request.env['HTTP_REFERER'] = 'where_i_came_from' }

        Then { expect { action }.not_to change(AcademicGroup, :count) }
        And  { expect(action).to redirect_to('where_i_came_from') }
        And  { is_expected.to set_flash[:danger] }
      end
    end

    context 'not signed in' do
      When { action }

      it_behaves_like :not_authenticated
    end
  end

  context 'post: :graduate' do
    Given(:group) { create :academic_group }
    Given(:action) { post :graduate, params: { id: group.id } }

    context 'not signed in' do
      When { action }

      it_behaves_like :not_authenticated
    end

    context 'signed in' do
      Given(:user) { create :person, roles: roles }

      When { sign_in user }

      context 'no rights' do
        Given(:roles) { [] }

        When { action }

        it_behaves_like :not_authorized
      end

      context 'valid rights' do
        Given(:roles) { [create(:role, activities: %w(academic_group:graduate))] }

        Given { expect(ClassScheduleWithPeople).to receive(:refresh_later) }

        When { action }

        Then { is_expected.to set_flash[:success] }
        And  { expect(response).to redirect_to(academic_group_path(group)) }
      end
    end
  end
end
