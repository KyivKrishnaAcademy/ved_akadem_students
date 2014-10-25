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

  context 'get: :index with ["akadem_group:new"]' do
    Given(:action)      { get :new }
    Given(:expectation) do
      expect(response).to render_template(:new)
      expect(assigns(:akadem_group)).to be_a_new(AkademGroup)
    end

    it_behaves_like :akadem_groups_actions, 'akadem_group:new'
  end

  context 'get: :index with ["akadem_group:show"]' do
    Given { @record = create :akadem_group }

    Given(:action)      { get :show, id: @record.id }
    Given(:expectation) do
      expect(response).to render_template(:show)
      expect(assigns(:akadem_group)).to eq(@record)
    end

    it_behaves_like :akadem_groups_actions, 'akadem_group:show'
  end

  context 'get: :index with ["akadem_group:edit"]' do
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

end
