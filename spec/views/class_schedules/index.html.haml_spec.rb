# require 'rails_helper'

include ReactOnRailsHelper

describe 'class_schedules/index' do
  Given(:page) { Capybara::Node::Simple.new(response.body) }
  Given(:user) { create :person, roles: [create(:role, activities: activities)] }
  Given(:activities) { %w(class_schedule:index) }

  Given { sign_in(user) }

  When  { render }

  describe 'conditional links' do
    Given(:new_link_text) { 'New Class Schedule' }

    context 'without additional rights' do
      Then { expect(page).not_to have_link(new_link_text, href: new_class_schedule_path) }
    end

    context 'with :new rights' do
      Given(:activities) { %w(class_schedule:index class_schedule:new) }

      Then { expect(page).to have_link(new_link_text, href: new_class_schedule_path) }
    end
  end
end
