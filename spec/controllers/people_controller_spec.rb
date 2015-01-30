require 'rails_helper'

describe PeopleController do
  describe 'not signed in' do
    context '#index' do
      Given(:action) { get :index }

      it_behaves_like :not_authenticated
    end

    context '#create' do
      Given(:action) { post :create }

      it_behaves_like :not_authenticated
    end

    context '#new' do
      Given(:action) { get :new }

      it_behaves_like :not_authenticated
    end

    context '#edit' do
      Given(:action) { get :edit, id: 1 }

      it_behaves_like :not_authenticated
    end

    context '#show' do
      Given(:action) { get :show, id: 1 }

      it_behaves_like :not_authenticated
    end

    context '#update' do
      Given(:action) { patch :update, id: 1 }

      it_behaves_like :not_authenticated
    end

    context '#destroy' do
      Given(:action) { delete :destroy, id: 1 }

      it_behaves_like :not_authenticated
    end

    context '#show_photo' do
      Given(:action) { get :show, id: 1, version: 'default' }

      it_behaves_like :not_authenticated
    end

    context '#show_passport' do
      Given(:action) { get :show, id: 1 }

      it_behaves_like :not_authenticated
    end

    shared_examples :not_authenticated_js do
      Then { expect(response.status).to eq(401) }
      And  { expect(response.body).to eq(I18n.t('devise.failure.unauthenticated')) }
    end

    context '#move_to_group' do
      When { patch :move_to_group, id: 1, group_id: 2, format: :js }

      it_behaves_like :not_authenticated_js
    end

    context '#remove_from_groups' do
      When { delete :remove_from_groups, id: 1, format: :js }

      it_behaves_like :not_authenticated_js
    end
  end

  describe 'with user' do
    Given(:person) { double(Person, id: 1, roles: roles) }
    Given(:people) { double }

    Given { allow(request.env['warden']).to receive(:authenticate!) { person } }
    Given { allow(controller).to receive(:current_person) { person } }
    Given { allow(person).to receive(:class).and_return(Person) }

    Given { allow_any_instance_of(PersonPolicy::Scope).to receive(:resolve).and_return(people) }
    Given { allow(people).to receive(:find).with('1').and_return(person) }

    Given(:other_person) { double(Person, id: 2) }

    Given { allow(other_person).to receive(:class).and_return(Person) }
    Given { allow(people).to receive(:find).with('2').and_return(other_person) }
    Given { allow(other_person).to receive(:photo_url).and_return('/photo_path') }

    shared_examples_for :get_show_photo_successed do |id|
      Then do
        expect(controller).to receive(:send_file).with('/photo_path',
                                                       disposition: 'inline',
                                                       type: 'image/jpeg',
                                                       x_sendfile: true)

        get :show_photo, id: id, version: 'default'
      end
    end

    describe 'regular user' do
      Given(:roles) { [] }

      shared_examples_for :not_authorized do |not_renderder_template|
        Then { expect(response).to redirect_to(root_path) }
        And  { expect(response).not_to render_template(not_renderder_template) }
        And  { is_expected.to set_the_flash[:danger].to(I18n.t(:not_authorized)) }
      end

      describe '#index' do
        When { get :index }

        it_behaves_like :not_authorized, 'index'
      end

      describe '#show' do
        When { get :show, id: 1 }

        it_behaves_like :not_authorized, 'show'
      end

      describe '#move_to_group' do
        When { patch :move_to_group, id: 1, group_id: 2, format: :js }

        it_behaves_like :not_authorized, 'move_to_group'
      end

      context '#remove_from_groups' do
        When { delete :remove_from_groups, id: 1, format: :js }

        it_behaves_like :not_authorized, 'remove_from_groups'
      end

      context '#show_photo' do
        Given { allow(controller).to receive(:render) }

        context 'self' do
          Given { allow(person).to receive(:photo_url).and_return('/photo_path') }

          it_behaves_like :get_show_photo_successed, 1
        end

        context 'other person' do
          context 'stranger' do
            Given { allow(person).to receive(:last_akadem_group).and_return(nil) }

            When  { get :show_photo, id: 2, version: 'default' }

            it_behaves_like :not_authorized, 'show_photo'
          end

          context 'classmate' do
            Given(:group) { double(AkademGroup, id: 3) }

            Given { allow(person).to receive(:last_akadem_group).and_return(group) }
            Given { allow(other_person).to receive(:last_akadem_group).and_return(group) }

            it_behaves_like :get_show_photo_successed, 2
          end

          context 'elder of person' do
            Given(:join) { double }
            Given(:groups) { double(any?: true) }

            Given { allow(AkademGroup).to receive(:joins).and_return(join) }
            Given { allow(join).to receive(:where).with(field => other_person.id, :student_profiles => { :person_id => person.id })
                                                  .and_return(groups) }

            context 'curator' do
              Given(:field) { :curator_id }

              it_behaves_like :get_show_photo_successed, 2
            end

            context 'administrator' do
              Given(:field) { :administrator_id }

              Given { allow(join).to receive(:where).with(:curator_id => other_person.id, :student_profiles => { :person_id => person.id })
                                                    .and_return([]) }

              it_behaves_like :get_show_photo_successed, 2
            end
          end
        end
      end
    end

    describe 'admin user' do
      Given(:roles) { double('roles', any?: true, name: 'Role') }

      describe '#index' do
        Given(:ordered_people) { double }

        Given { allow(roles).to receive_message_chain(:select, :distinct, :map, :flatten) { ['person:index'] } }
        Given { allow(people).to receive_message_chain(:by_complex_name, :page).and_return(ordered_people) }

        When  { get :index }

        Then { expect(response).to render_template(:index) }
        And  { expect(assigns(:people)).to eq(ordered_people) }
      end

      describe '#show' do
        Given(:akadem_groups) { double }
        Given(:programs) { double }

        Given { allow(roles).to receive_message_chain(:select, :distinct, :map, :flatten) { ['person:show'] } }
        Given { allow(person).to receive(:can_act?).with('study_application:create') { true } }
        Given { allow(person).to receive(:is_a?).and_return(false) }
        Given { allow(person).to receive(:is_a?).with(Person).and_return(true) }
        Given { allow(AkademGroup).to receive_message_chain(:select, :order) { akadem_groups } }
        Given { allow(Program).to receive(:all) { programs } }

        When  { get :show, id: 1 }

        Then { expect(response).to render_template(:show) }
        And  { expect(assigns(:person)).to eq(person) }
        And  { expect(assigns(:akadem_groups)).to eq(akadem_groups) }
        And  { expect(assigns(:person_decorator)).to be_a(PersonDecorator) }
        And  { expect(assigns(:programs)).to eq(programs) }
        And  { expect(assigns(:study_application)).to be_a_new(StudyApplication) }
      end

      describe '#move_to_group' do
        Given(:akadem_group) { double }
        Given(:student_profile) { double }

        Given { allow(roles).to receive_message_chain(:select, :distinct, :map, :flatten) { ['person:move_to_group'] } }
        Given { allow(AkademGroup).to receive(:find).with('2').and_return(akadem_group) }
        Given { allow(person).to receive(:student_profile).and_return(nil) }
        Given { allow(person).to receive(:create_student_profile).and_return(student_profile) }
        Given { allow(student_profile).to receive(:move_to_group).with(akadem_group) }

        When { patch :move_to_group, id: 1, group_id: 2, format: :js }

        Then { expect(response).to render_template(:move_to_group) }
      end

      describe '#remove_from_groups' do
        Given(:student_profile) { double }

        Given { allow(roles).to receive_message_chain(:select, :distinct, :map, :flatten) { ['person:remove_from_groups'] } }
        Given { allow(person).to receive(:student_profile).and_return(student_profile) }
        Given { expect(student_profile).to receive(:remove_from_groups) }

        When { delete :remove_from_groups, id: 1, format: :js }

        Then { expect(response).to render_template(:remove_from_groups) }
      end

      describe '#show_photo' do
        Given { allow(controller).to receive(:render) }
        Given { allow(roles).to receive_message_chain(:select, :distinct, :map, :flatten) { ['person:show'] } }

        it_behaves_like :get_show_photo_successed, 2
      end
    end
  end

  describe 'old specs to rewrite' do
    When { sign_in :person, create(:person, :admin) }

    describe "POST 'create'" do
      When { post :create, person: build(:person).attributes.merge(telephones_attributes: [build(:telephone).attributes]) }

      context 'on success' do
        context 'redirect and flash' do
          Then { expect(response.status).to redirect_to(action: :new) }
          And  { is_expected.to set_the_flash[:success] }
        end

        context '@person' do
          Then { expect(assigns(:person)).to be_a(Person)  }
          And  { expect(assigns(:person)).to be_persisted }
        end
      end

      context 'on failure' do
        Given { allow_any_instance_of(Person).to receive(:save).and_return(false) }

        context 'render' do
          Then  { expect(response.status).to render_template(:new) }
        end

        context '@person' do
          Then { expect(assigns(:person)).not_to be_persisted }
        end
      end
    end

    it_behaves_like "GET", :person, Person, :new
    it_behaves_like "GET", :person, Person, :edit
    it_behaves_like "DELETE 'destroy'", Person

    describe "PATCH 'update'" do
      Given(:person) { create :person }

      def update_model(attributes = nil)
        person.emergency_contact = 'Какой-то текст'

        attributes ||= person.attributes.merge(skip_password_validation: true)

        patch :update, { id: person.id, person: attributes }
      end

      context 'on success' do
        context 'field chenged' do
          Then { expect{ update_model }.to change{ person[:emergency_contact] }.to('Какой-то текст') }
        end

        context 'receives .update_attributes' do
          Then do
            expect_any_instance_of(Person).to receive(:update_attributes).with( 'emergency_contact' => 'params',
                                                                                'skip_password_validation' => true)

            update_model('emergency_contact' => 'params')
          end
        end

        context 'flash and redirect' do
          When { update_model }

          Then { is_expected.to set_the_flash[:success] }
          And  { expect(response.status).to redirect_to person }
        end
      end

      context 'on failure' do
        Given { allow_any_instance_of(Person).to receive(:save).and_return(false) }

        When  { update_model }

        Then  { expect(response.status).to render_template(:edit) }
      end
    end

    Given(:mod_params) do
      {
        name:               'Василий',
        spiritual_name:     'Сарва Сатья дас',
        middle_name:        'Тигранович',
        surname:            'Киселев',
        email:              'ssd@pamho.yes',
        gender:             true,
        birthday:           7200.days.ago.to_date,
        education:          'Брахмачарьи ашрам',
        work:               'ББТ',
        emergency_contact:  'Харе Кришна Харе Кришна Кришна Кришна Харе Харе',
        telephones_attributes:  [ id: nil,
                                  phone: '+380 50 111 2233']
      }
    end

    it_behaves_like :controller_params_subclass, PeopleController::PersonParams, :person

    describe 'direct to crop path' do
      describe 'create' do
        Given (:person_attributes) { build(:person).attributes.merge(password: 'password',
                                                                     password_confirmation: 'password',
                                                                     telephones_attributes: { '0' => { phone: '+380 50 111 2233'}}) }

        context 'has photo' do
          When { post :create, person: person_attributes.merge(photo: 'test.png') }

          Then { expect(response.status).to redirect_to(crop_image_path(assigns(:person).id)) }
        end

        context 'has no photo' do
          When { post :create, person: person_attributes }

          Then { expect(response.status).to redirect_to(action: :new) }
        end
      end

      describe 'update' do
        Given { @person = create(:person) }
        Given (:person_attributes) { @person.attributes.merge(password: 'password',
                                                                      password_confirmation: 'password',
                                                                      telephones_attributes: { '0' => { phone: '+380 50 111 2233'}}) }

        context 'has photo' do
          When { patch :update, id: @person.id, person: person_attributes.merge(photo: 'test.png') }

          Then { expect(response.status).to redirect_to(crop_image_path(@person.id)) }
        end

        context 'has no photo' do
          When { patch :update, id: @person.id, person: person_attributes }

          Then { expect(response.status).to redirect_to(person_path(@person.id)) }
        end
      end
    end
  end
end
