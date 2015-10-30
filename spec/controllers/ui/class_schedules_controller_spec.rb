require 'rails_helper'

describe Ui::ClassSchedulesController do
  describe 'not signed in' do
    context '#person' do
      When { get :person, format: :json }

      include_examples :ui_not_authenticated
    end

    context '#academic_group' do
      When { get :academic_group, id: 1, format: :json }

      include_examples :ui_not_authenticated
    end
  end

  describe 'signed in' do
    Given(:action) { get :person, format: :json }
    Given(:person) { create :person }

    Given { sign_in person }

    context '#person' do
      describe 'as regular user' do
        When { action }

        include_examples :ui_not_authorized
      end

      describe 'as teacher' do
        Given { person.create_teacher_profile }

        Then  { expect(Ui::PersonClassSchedulesLoadingInteraction).to receive(:new) }
        And   { action }
      end

      describe 'as student' do
        Given { person.create_student_profile }

        context 'no group' do
          When { action }

          include_examples :ui_not_authorized
        end

        context 'with group' do
          Given(:group) { create :academic_group }

          Given { person.student_profile.academic_groups << group }

          context 'active' do
            Then { expect(Ui::PersonClassSchedulesLoadingInteraction).to receive(:new) }
            And  { action }
          end

          context 'inactive' do
            Given { person.student_profile.group_participations.first.leave! }

            When  { action }

            include_examples :ui_not_authorized
          end
        end
      end
    end

    context '#academic_group' do
      Given(:action) { get :academic_group, id: group.id, format: :json }
      Given(:group) { create :academic_group }

      shared_examples :valid_group_schedules_loading do
        Then { expect(Ui::GroupClassSchedulesLoadingInteraction).to receive(:new) }
        And  { action }
      end

      describe 'as regular user' do
        When { action }

        include_examples :ui_not_authorized
      end

      describe 'with academic_group:show' do
        Given { person.roles << create(:role, activities: ['academic_group:show']) }

        include_examples :valid_group_schedules_loading
      end

      describe 'as student' do
        Given { person.create_student_profile }

        context 'no group' do
          When { action }

          include_examples :ui_not_authorized
        end

        context 'with this group' do
          Given { person.student_profile.academic_groups << group }

          context 'active' do
            include_examples :valid_group_schedules_loading
          end

          context 'inactive' do
            Given { person.student_profile.group_participations.first.leave! }

            When  { action }

            include_examples :ui_not_authorized
          end
        end

        context 'with other group' do
          Given(:other_group) { create :academic_group }

          Given { person.student_profile.academic_groups << other_group }

          When  { action }

          include_examples :ui_not_authorized
        end
      end

      describe 'as curator' do
        Given { group.update_column(:curator_id, person.id) }

        include_examples :valid_group_schedules_loading
      end

      describe 'as administrator' do
        Given { group.update_column(:administrator_id, person.id) }

        include_examples :valid_group_schedules_loading
      end
    end
  end
end
