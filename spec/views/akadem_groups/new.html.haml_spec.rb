require 'rails_helper'

describe 'academic_groups/new' do
  before do
    login_as_admin
    visit new_academic_group_path
  end

  subject { page }

  let(:title)   { 'Add New Academic Group' }
  let(:h1)      { 'Add Academic Group' }
  let(:action)  { 'new' }

  it_behaves_like 'academic group new and edit'

  describe 'Establishment date = Time#now by default' do
    Given(:today) { Time.zone.today }

    Then { is_expected.to have_selector('#academic_group_establ_date_1i option[selected]', text: today.year) }
    And  { is_expected.to have_selector('#academic_group_establ_date_3i option[selected]', text: today.day) }

    And do
      is_expected.to(
        have_selector('#academic_group_establ_date_2i option[selected]', text: I18n.t('date.month_names')[today.mon])
      )
    end
  end
end
