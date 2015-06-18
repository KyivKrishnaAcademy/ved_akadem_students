require 'rails_helper'

describe Ui::ClassSchedulesController do
  describe 'not signed in' do
    context '#person' do
      When { get :person, format: :json }

      it_behaves_like :ui_not_authenticated
    end
  end

  describe 'signed in' do
    Given(:person) { create :person }

    Given { sign_in person }

    context '#person' do
      describe 'as regular user' do
        When { get :person, format: :json }

        it_behaves_like :ui_not_authorized
      end

      describe 'as teacher' do
        Given { person.create_teacher_profile }

        Then  { expect(PersonClassSchedulesLoadingInteraction).to receive(:new) }
        And   { get :person, format: :json }
      end

      describe 'as student' do
        Given { person.create_student_profile }

        context 'no group' do
          When { get :person, format: :json }

          it_behaves_like :ui_not_authorized
        end

        context 'with group' do
          Given(:group) { create :academic_group }

          Given { person.student_profile.academic_groups << group }

          context 'active' do
            Then { expect(PersonClassSchedulesLoadingInteraction).to receive(:new) }
            And  { get :person, format: :json }
          end

          context 'inactive' do
            Given { person.student_profile.group_participations.first.leave! }

            When  { get :person, format: :json }

            it_behaves_like :ui_not_authorized
          end
        end
      end
    end
  end
end
