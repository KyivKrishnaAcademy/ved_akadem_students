require 'rails_helper'

describe 'Locales' do
  Given!(:person) { create :person }

  context 'anonymous user' do
    Given { visit root_path }

    describe 'should toggle locale forward' do
      Given!(:prev_locale_label) { toggle_link.text }

      When { toggle_link.click }

      Then { expect(prev_locale_label).not_to eq(toggle_link.text) }

      describe 'should toggle locale backward' do
        When { toggle_link.click }

        Then { expect(prev_locale_label).to eq(toggle_link.text) }
      end

      describe 'should not write to DB' do
        Then { expect {toggle_link.click}.not_to change {Person.order(:id).reload.pluck(:locale)} }
      end
    end
  end

  context 'user logged in' do
    Given { login_as(person) }
    Given { visit root_path }

    describe 'should toggle locale forward' do
      Given!(:prev_locale_label) { toggle_link.text }

      When { toggle_link.click }

      Then { expect(prev_locale_label).not_to eq(toggle_link.text) }

      describe 'should toggle locale backward' do
        When { toggle_link.click }

        Then { expect(prev_locale_label).to eq(toggle_link.text) }
      end

      describe 'should not write to DB' do
        Then { expect {toggle_link.click}.to change {person.reload.locale} }
      end
    end
  end

  def toggle_link
    # need to be always fresh, do not convert to 'let'
    find('header a', text: I18n.t(:locale_label))
  end
end
