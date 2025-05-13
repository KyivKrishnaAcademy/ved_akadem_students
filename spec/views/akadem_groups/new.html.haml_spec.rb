# require 'rails_helper'

describe 'academic_groups/new' do
  before do
    login_as_admin
    visit new_academic_group_path
  end

  subject { page }

  it_behaves_like 'academic group new and edit', 'new'

  describe 'Establishment date = Time#now by default' do
    Given(:today) { Time.zone.today }

    Then { expect(find('input#academic_group_establ_date').value).to eq(I18n.l(today, format: :date_picker)) }
  end
end
