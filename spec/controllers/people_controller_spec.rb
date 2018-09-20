require 'rails_helper'

describe PeopleController do
  Given(:params) { { person: { some_param: true } } }

  describe 'not signed in' do
    it_behaves_like :failed_auth_crud, :not_authenticated

    context '#show_photo' do
      When { get :show, params: { id: 1, version: 'default' } }

      it_behaves_like :not_authenticated
    end
  end

  describe 'with user' do
    Given(:person) { build_stubbed(:person, id: 1) }
    Given(:people) { double }

    Given { allow(request.env['warden']).to receive(:authenticate!) { person } }
    Given { allow(controller).to receive(:current_person) { person } }
    Given { allow(person).to receive(:class).and_return(Person) }

    Given { allow_any_instance_of(PersonPolicy::Scope).to receive(:resolve).and_return(people) }
    Given { allow(people).to receive(:find).with('1').and_return(person) }

    Given(:other_person) { double(Person, id: 2) }
    Given(:group) { double(AcademicGroup, id: 3) }

    Given do
      allow(other_person).to receive_message_chain(:student_profile, :academic_groups, :where, :ids)
        .and_return([group.id])
    end

    Given { allow(other_person).to receive(:class).and_return(Person) }
    Given { allow(people).to receive(:find).with('2').and_return(other_person) }
    Given { allow(other_person).to receive(:photo_url).and_return('/photo_path') }

    shared_examples_for :get_show_photo_successed do |id|
      Then do
        expect(controller).to receive(:send_file).with('/photo_path',
                                                       disposition: 'inline',
                                                       type: 'image/jpeg',
                                                       x_sendfile: true) { controller.head :ok }

        get :show_photo, params: { id: id, version: 'default' }
      end
    end

    describe 'regular user' do
      it_behaves_like :failed_auth_crud, :not_authorized

      context '#show_photo' do
        Given { allow(controller).to receive(:render) }

        context 'self' do
          Given { allow(person).to receive(:photo_url).and_return('/photo_path') }

          it_behaves_like :get_show_photo_successed, 1
        end

        context 'other person' do
          context 'stranger' do
            Given do
              allow(person).to receive_message_chain(:student_profile, :academic_groups, :where, :ids).and_return([])
            end

            When { get :show_photo, params: { id: 2, version: 'default' } }

            it_behaves_like :not_authorized
          end

          context 'classmate' do
            Given(:group) { double(AcademicGroup, id: 3) }

            Given do
              allow(person).to receive_message_chain(:student_profile, :academic_groups, :where, :ids)
                .and_return([group.id])
            end

            it_behaves_like :get_show_photo_successed, 2
          end

          context 'elder of person' do
            Given(:join) { double }
            Given(:groups) { double(any?: true) }

            Given { allow(AcademicGroup).to receive(:joins).and_return(join) }

            Given do
              allow(join).to receive(:where)
                .with(field => other_person.id, :student_profiles => { person_id: person.id })
                .and_return(groups)
            end

            context 'curator' do
              Given(:field) { :curator_id }

              it_behaves_like :get_show_photo_successed, 2
            end

            context 'administrator' do
              Given(:field) { :administrator_id }

              Given do
                allow(join).to receive(:where)
                  .with(
                    curator_id: other_person.id,
                    student_profiles: {
                      person_id: person.id
                    }
                  )
                  .and_return([])
              end

              it_behaves_like :get_show_photo_successed, 2
            end
          end
        end
      end
    end

    describe 'admin user' do
      Given(:roles) { double('roles', any?: true, name: 'Role') }

      Given { allow(person).to receive(:roles).and_return(roles) }

      describe '#index' do
        Given(:ordered_people) { double }

        Given { allow(roles).to receive_message_chain(:select, :distinct, :map, :flatten) { ['person:index'] } }
        Given { allow(people).to receive_message_chain(:by_complex_name, :page).and_return(ordered_people) }

        When  { get :index }

        Then { expect(response).to render_template(:index) }
        And  { expect(assigns(:people)).to eq(ordered_people) }
      end

      describe '#show' do
        Given(:academic_groups) { double }
        Given(:programs) { double }

        Given { allow(roles).to receive_message_chain(:select, :distinct, :map, :flatten) { ['person:show'] } }
        Given { allow(person).to receive(:can_act?).with('study_application:create') { true } }
        Given { allow(person).to receive(:is_a?).and_return(false) }
        Given { allow(person).to receive(:is_a?).with(Person).and_return(true) }
        Given { allow(person).to receive(:reload).and_return(person) }
        Given { allow(AcademicGroup).to receive_message_chain(:active, :select) { academic_groups } }
        Given { allow(Program).to receive(:all) { programs } }

        When  { get :show, params: { id: 1 } }

        Then { expect(response).to render_template(:show) }
        And  { expect(assigns(:person)).to eq(person) }
        And  { expect(assigns(:academic_groups)).to eq(academic_groups) }
        And  { expect(assigns(:application_person)).to be_a(Person) }
        And  { expect(assigns(:programs)).to eq(programs) }
        And  { expect(assigns(:new_study_application)).to be_a_new(StudyApplication) }
      end

      describe '#show_photo' do
        Given { allow(controller).to receive(:render) }
        Given { allow(roles).to receive_message_chain(:select, :distinct, :map, :flatten) { ['person:show'] } }

        it_behaves_like :get_show_photo_successed, 2
      end
    end
  end

  describe 'old specs to rewrite' do
    When { sign_in create(:person, :admin) }

    describe "POST 'create'" do
      Given(:params) do
        { person: build(:person).attributes.merge(telephones_attributes: [build(:telephone).attributes]) }
      end

      When { post :create, params: params }

      context 'on success' do
        context 'redirect and flash' do
          Then { expect(response.status).to redirect_to(action: :new) }
          And  { is_expected.to set_flash[:success] }
        end

        context '@person' do
          Then { expect(assigns(:person)).to be_a(Person) }
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

    it_behaves_like 'GET', :person, Person, :new
    it_behaves_like 'GET', :person, Person, :edit
    it_behaves_like "DELETE 'destroy'", Person

    describe "PATCH 'update'" do
      Given(:person) { create :person }

      def update_model(attributes = nil)
        person.emergency_contact = 'Какой-то текст'

        attributes ||= person.attributes.merge(skip_password_validation: true)

        patch :update, params: { id: person.id, person: attributes }
      end

      Given { expect(ClassScheduleWithPeople).to receive(:refresh_later) }

      context 'on success' do
        context 'field chenged' do
          Then { expect { update_model }.to change { person[:emergency_contact] }.to('Какой-то текст') }
        end

        context 'receives .update_attributes' do
          Then do
            expect_any_instance_of(Person).to receive(:update).with(
              ActionController::Parameters.new(
                'emergency_contact' => 'params',
                'skip_password_validation' => true
              ).permit!
            )

            update_model('emergency_contact' => 'params')
          end
        end

        context 'flash and redirect' do
          When { update_model }

          Then { is_expected.to set_flash[:success] }
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
        telephones_attributes: [
          id: nil,
          phone: '+380 50 111 2233'
        ]
      }
    end

    it_behaves_like :controller_params_subclass, PeopleController::PersonParams, :person

    describe 'direct to crop path' do
      describe 'create' do
        Given(:person_attributes) do
          build(:person)
            .attributes
            .merge(
              password: 'password',
              password_confirmation: 'password',
              telephones_attributes: { '0' => { phone: '+380 50 111 2233' } }
            )
        end

        context 'has photo' do
          When { post :create, params: { person: person_attributes.merge(photo: 'test.png') } }

          Then { expect(response.status).to redirect_to(crop_image_path(assigns(:person).id)) }
        end

        context 'has no photo' do
          When { post :create, params: { person: person_attributes } }

          Then { expect(response.status).to redirect_to(action: :new) }
        end
      end

      describe 'update' do
        Given(:person) { create :person }
        Given(:person_attributes) do
          person
            .attributes
            .merge(
              password: 'password',
              password_confirmation: 'password',
              telephones_attributes: { '0' => { phone: '+380 50 111 2233' } }
            )
        end

        context 'has photo' do
          When { patch :update, params: { id: person.id, person: person_attributes.merge(photo: 'test.png') } }

          Then { expect(response.status).to redirect_to(crop_image_path(person.id)) }
        end

        context 'has no photo' do
          When { patch :update, params: { id: person.id, person: person_attributes } }

          Then { expect(response.status).to redirect_to(person_path(person.id)) }
        end
      end
    end
  end
end
