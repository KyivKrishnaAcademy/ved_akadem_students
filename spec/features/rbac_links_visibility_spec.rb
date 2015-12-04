require 'rails_helper'

describe 'RBAC links visibility' do
  shared_examples :nav_links do |locator, href, *activities|
    context "with activities #{activities.flatten.inspect}" do
      When { login_as(user) }
      When { visit '/' }

      describe "should see link '#{locator}' href: #{href}" do
        Given(:user) { create :person, roles: [create(:role, activities: activities.flatten)] }

        Then  { expect(find('header .navbar-nav')).to have_css("a[href=\"#{href}\"]", text: locator, visible: false) }
      end

      describe 'should not see it with all other activities' do
        Given(:user) { create :person, roles: [create(:role, activities: (all_activities - activities.flatten))] }

        Then  { expect(find('header .navbar-nav')).not_to have_css("a[href=\"#{href}\"]", text: locator, visible: false) }
      end
    end
  end

  %w(academic_group person course class_schedule certificate_template).each do |model|
    include_examples :nav_links, I18n.t("defaults.links.#{model.pluralize}"), '#', %W(#{model}:new #{model}:index)
    include_examples :nav_links, I18n.t("defaults.links.#{model.pluralize}_add"), "/#{model.pluralize}/new", "#{model}:new"
    include_examples :nav_links, I18n.t("defaults.links.#{model.pluralize}_list"), "/#{model.pluralize}", "#{model}:index"
  end
end
