# require 'rails_helper'

describe Ui::PeopleController do
  describe 'not signed in' do
    Given { expect(ClassScheduleWithPeople).not_to receive(:refresh_later) }

    context '#move_to_group' do
      When { patch :move_to_group, params: { id: 1, group_id: 2 }, format: :json }

      it_behaves_like :ui_not_authenticated
    end
  end

  describe 'with user' do
    Given(:group) { create :academic_group }
    Given(:person) { create :person, roles: [create(:role, activities: activities)] }
    Given(:activities) { ['person:show'] }
    Given(:other_person) { create :person }
    Given(:move_to_group_action) do
      patch :move_to_group, params: { id: other_person.id, group_id: group.id }, format: :json
    end

    Given { sign_in person }

    describe 'regular user' do
      Given { expect(ClassScheduleWithPeople).not_to receive(:refresh_later) }

      describe '#move_to_group' do
        When { move_to_group_action }

        it_behaves_like :ui_not_authorized
      end
    end

    describe 'admin user' do
      Given { expect(ClassScheduleWithPeople).to receive(:refresh_later) }

      describe '#move_to_group' do
        Given(:activities) { ['person:move_to_group'] }
        Given(:parsed_response) { JSON.parse(response.body, symbolize_names: true) }
        Given(:expected_response) do
          {
            id: group.id,
            title: group.title,
            url: academic_group_path(group)
          }
        end

        When  { move_to_group_action }

        Then  { expect(response.status).to eq(200) }
        And   { expect(parsed_response).to eq(expected_response) }
      end
    end
  end
end
