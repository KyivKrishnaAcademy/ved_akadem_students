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

  it_behaves_like :nav_links, I18n.t('defaults.links.academic_groups'), '#', %w(academic_group:new academic_group:index)
  it_behaves_like :nav_links, I18n.t('defaults.links.academic_groups_add'), '/academic_groups/new', 'academic_group:new'
  it_behaves_like :nav_links, I18n.t('defaults.links.academic_groups_list'), '/academic_groups', 'academic_group:index'

  it_behaves_like :nav_links, I18n.t('defaults.links.people'), '#', %w(person:new person:index)
  it_behaves_like :nav_links, I18n.t('defaults.links.people_add'), '/people/new', 'person:new'
  it_behaves_like :nav_links, I18n.t('defaults.links.people_list'), '/people', 'person:index'

  it_behaves_like :nav_links, I18n.t('defaults.links.courses'), '#', %w(course:new course:index)
  it_behaves_like :nav_links, I18n.t('defaults.links.courses_add'), '/courses/new', 'course:new'
  it_behaves_like :nav_links, I18n.t('defaults.links.courses_list'), '/courses', 'course:index'

  it_behaves_like :nav_links, I18n.t('defaults.links.class_schedules'), '#', %w(class_schedule:new class_schedule:index)
  it_behaves_like :nav_links, I18n.t('defaults.links.class_schedules_add'), '/class_schedules/new', 'class_schedule:new'
  it_behaves_like :nav_links, I18n.t('defaults.links.class_schedules_list'), '/class_schedules', 'class_schedule:index'
end
