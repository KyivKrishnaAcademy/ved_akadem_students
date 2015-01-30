require 'rails_helper'

describe AkademGroupsController do
  Given (:mod_params) do
    { group_name:         'ШБ13-5',
      establ_date:        3600.days.ago.to_date.to_s,
      group_description:  'Харе Кришна Харе Кришна Кришна Кришна Харе Харе'  }
  end

  describe 'params' do
    it_behaves_like :controller_params_subclass, AkademGroupsController::AkademGroupParams, :akadem_group
  end

  shared_examples :akadem_groups_actions do |*activities|
    context 'signed in' do
      When { sign_in(:person, @user) }
      When { action }

      describe 'should allow' do
        Given { @user = create :person, roles: [create(:role, activities: activities.flatten)] }

        Then  { expectation }
      end

      describe 'should not allow with other activities' do
        Given { @user = create :person, roles: [create(:role, activities: (all_activities - activities.flatten))] }

        Then  { is_expected.to set_the_flash[:danger].to(I18n.t('not_authorized')) }
        And   { expect(response).to redirect_to(root_path) }
      end
    end

    context 'not signed in' do
      When { action }

      Then { expect(response).to redirect_to(new_person_session_path) }
      And  { is_expected.to set_the_flash[:alert].to(I18n.t('devise.failure.unauthenticated')) }
    end
  end

  context 'get: :autocomplete_person with ["akadem_group:edit"]' do
    Given(:action) { get :autocomplete_person, term: 'phasotron', format: :json }

    context 'signed in' do
      When { sign_in(:person, user) }
      When { action }

      describe 'should allow' do
        Given(:user) { create :person, roles: [create(:role, activities: ['akadem_group:edit'])] }

        context 'when there are results' do
          Given { @person = create :person, name: 'Synchrophasotronus' }

          Then  { expect(response.body).to eq([{ id: @person.id.to_s, label: @person.complex_name, value: @person.complex_name }].to_json) }
        end

        context 'when there are no results' do
          Then { expect(response.body).to eq([].to_json) }
        end
      end

      describe 'should not allow with other activities' do
        Given(:user) { create :person, roles: [create(:role, activities: (all_activities - ['akadem_group:edit']))] }

        Then  { is_expected.to set_the_flash[:danger].to(I18n.t('not_authorized')) }
        And { expect(response).to redirect_to(root_path) }
      end
    end

    context 'not signed in' do
      When { action }

      Then { expect(response.status).to eq(401) }
    end
  end

  context 'post: :create with ["akadem_group:create"]' do
    Given(:action)      { post :create, akadem_group: { group_name: 'ШБ00-1', group_description: 'aaaaaaaaaa', establ_date: DateTime.now } }
    Given(:expectation) do
      expect(response).to redirect_to(action: :new)
      is_expected.to set_the_flash[:success]
      expect(assigns(:akadem_group)).to be_a(AkademGroup)
      expect(assigns(:akadem_group)).to be_persisted
    end

    it_behaves_like :akadem_groups_actions, 'akadem_group:create'

    describe 'on failure with valid rights' do
      Given { allow_any_instance_of(AkademGroup).to receive(:save).and_return(false) }

      When  { sign_in :person, create(:person, roles: [create(:role, activities: %w[akadem_group:create])]) }
      When  { action }

      Then  { expect(response).to render_template(:new) }
      And   { expect(assigns(:akadem_group)).not_to be_persisted }
    end
  end

  context 'get: :index with ["akadem_group:index"]' do
    Given { allow(AkademGroup).to receive(:all).and_return('some records') }

    Given(:action)      { get :index }
    Given(:expectation) do
      expect(response).to render_template(:index)
      expect(assigns(:akadem_groups)).to eq('some records')
    end

    it_behaves_like :akadem_groups_actions, 'akadem_group:index'
  end

  context 'get: :new with ["akadem_group:new"]' do
    Given(:action)      { get :new }
    Given(:expectation) do
      expect(response).to render_template(:new)
      expect(assigns(:akadem_group)).to be_a_new(AkademGroup)
    end

    it_behaves_like :akadem_groups_actions, 'akadem_group:new'
  end

  context 'get: :show with ["akadem_group:show"]' do
    Given(:action) { get :show, id: group.id }
    Given(:expectation) do
      expect(response).to render_template(:show)
      expect(assigns(:akadem_group)).to eq(group)
    end

    describe 'DB hit tests' do
      Given(:group) { create :akadem_group }

      it_behaves_like :akadem_groups_actions, 'akadem_group:show'
    end

    describe 'DBless tests' do
      Given(:person) { double(Person, id: 1, roles: []) }
      Given(:groups) { double }
      Given(:group)  { double(AkademGroup, id: 1) }

      Given { allow(request.env['warden']).to receive(:authenticate!) { person } }
      Given { allow(controller).to receive(:current_person) { person } }

      Given { allow(group).to receive(:class).and_return(AkademGroup) }
      Given { allow_any_instance_of(AkademGroupPolicy::Scope).to receive(:resolve).and_return(groups) }
      Given { allow(groups).to receive(:find).with('1').and_return(group) }

      context 'user is student of the group' do
        Given(:student_profile) { double(StudentProfile) }

        Given { allow(person).to receive(:student_profile).and_return(student_profile) }
        Given { allow(group).to receive(:active_student_profiles).and_return([student_profile]) }

        When { action }

        Then { expectation }
      end

      describe 'curator and administrator' do
        Given { allow_any_instance_of(AkademGroupPolicy).to receive(:student_of_the_group?).and_return(false) }

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

  context 'get: :edit with ["akadem_group:edit"]' do
    Given { @record = create :akadem_group }

    Given(:action)      { get :edit, id: @record.id }
    Given(:expectation) do
      expect(response).to render_template(:edit)
      expect(assigns(:akadem_group)).to eq(@record)
    end

    it_behaves_like :akadem_groups_actions, 'akadem_group:edit'
  end

  context 'patch: :update with ["akadem_group:update"]' do
    Given { @record = create :akadem_group }

    Given(:action)      { patch :update, { id: @record.id, akadem_group: mod_params }  }
    Given(:expectation) do
      expect(response).to redirect_to(@record)
      expect(assigns(:akadem_group)).to eq(@record)
      is_expected.to set_the_flash[:success]
    end

    it_behaves_like :akadem_groups_actions, 'akadem_group:update'

    describe 'other' do
      When { sign_in :person, create(:person, roles: [create(:role, activities: %w[akadem_group:update])]) }

      describe 'record receives update' do
        Then do
          expect_any_instance_of(AkademGroup).to receive(:update_attributes).with(mod_params.with_indifferent_access)
          action
        end
      end

      describe 'on failure with valid rights' do
        Given { allow_any_instance_of(AkademGroup).to receive(:save).and_return(false) }

        When  { action }

        Then  { expect(response.status).to render_template(:edit) }
      end
    end
  end

  context 'delete: :destroy with ["akadem_group:destroy"]' do
    Given { @record = create :akadem_group }

    Given(:action) { delete :destroy, id: @record.id }

    context 'signed in' do
      Given { @user = create :person, roles: [create(:role, activities: %w[akadem_group:destroy])] }

      When { sign_in(:person, @user) }

      context 'on success' do
        Then { expect{action}.to change(AkademGroup, :count).by(-1) }
        And  { expect(action).to redirect_to(action: :index)  }
        And  { is_expected.to set_the_flash[:success] }
      end

      context 'on failure' do
        Given { allow_any_instance_of(AkademGroup).to receive_message_chain(:destroy, :destroyed?).and_return(false) }
        Given { request.env['HTTP_REFERER'] = 'where_i_came_from' }

        Then { expect{action}.not_to change(AkademGroup, :count) }
        And  { expect(action).to redirect_to('where_i_came_from') }
        And { is_expected.to set_the_flash[:danger] }
      end
    end

    context 'not signed in' do
      it_behaves_like :not_authenticated
    end
  end
end
