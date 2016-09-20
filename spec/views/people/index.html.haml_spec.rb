require 'rails_helper'

describe 'people/index' do
  Given(:page) { Capybara::Node::Simple.new(response.body) }
  Given(:user) { create :person, roles: [create(:role, activities: activities)] }
  Given(:person) { create :person }
  Given(:activities) { %w(person:index person:show) }

  Given do
    [user, person].each do |record|
      allow(view).to receive(:policy).with(record).and_return(PersonPolicy.new(user, record))
    end
  end

  Given { assign(:people, Kaminari.paginate_array(Person.by_complex_name).page(1)) }
  Given { login_as(user) }

  When  { render }

  describe 'title and h1' do
    Then { expect(page).to have_selector('h1', text: 'People') }
  end

  describe 'table' do
    Then { expect(page.find('.table')).to have_selector('tbody tr', count: 2) }

    ['#', 'Photo', 'Full Name', 'Group or Application'].each do |header|
      And { expect(page.find('.table')).to have_selector('th', text: header) }
    end
  end

  describe 'link to person' do
    context 'with show rights' do
      Then do
        expect(page.find('tbody tr', text: user.complex_name))
          .to have_link(user.complex_name, href: person_path(user))
      end

      And do
        expect(page.find('tbody tr', text: person.complex_name))
          .to have_link(person.complex_name, href: person_path(person))
      end
    end

    context 'without show rights' do
      Given(:activities) { %w(person:index) }

      Then do
        expect(page.find('tbody tr', text: user.complex_name))
          .not_to have_link(user.complex_name, href: person_path(user))
      end

      And do
        expect(page.find('tbody tr', text: person.complex_name))
          .not_to have_link(person.complex_name, href: person_path(person))
      end
    end
  end
end
