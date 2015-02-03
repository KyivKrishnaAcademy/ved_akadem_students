require 'rails_helper'

describe 'people/index' do
  # TODO
  Given { 4.times { create :person } }
  Given { login_as_admin }

  When  { visit people_path }

  describe 'title and h1' do
    Then { expect(page).to have_title(full_title('All People')) }
    And  { expect(find('body')).to have_selector('h1', text: 'People')  }
  end

  describe 'table' do
    Then { expect(find('.table')).to have_selector('tbody tr', count: 5 ) }

    ['#', 'Photo', 'Full Name', 'Group or Application'].each do |header|
      And { expect(find('.table')).to have_selector('th', text: header) }
    end
  end
end
