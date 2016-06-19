require 'rails_helper'

describe Ui::PersonGroupUpdatingInteraction do
  Given(:title) { 'ШБ10-1' }
  Given(:group) { create :academic_group, title: title }
  Given(:params) { ActionController::Parameters.new({ group_id: group.id }) }
  Given(:student) { create :person }
  Given(:interaction) { described_class.new(params: params, resource: student) }

  describe 'calls ClassSchedule#personal_schedule' do
    Given(:mail) { double }
    Given(:expected_json) do
      {
        id: group.id,
        title: title,
        url: Rails.application.routes.url_helpers.academic_group_path(group)
      }
    end

    Then { expect(GroupTransactionsMailer).to receive(:join_the_group).with(group, student).and_return(mail) }
    And  { expect(mail).to receive(:deliver_later) }
    And  { expect(interaction.as_json).to eq(expected_json) }
  end
end
