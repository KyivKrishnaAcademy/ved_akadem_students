require 'rails_helper'

describe 'RBAC links visibility' do
  shared_examples :nav_links do |locator, href, *activities|
    context "with activities #{activities.flatten.inspect}" do
      When  { login_as_user(@user) }

      describe "should see link '#{locator}' href: #{href}" do
        Given { @user = create :person, roles: [create(:role, activities: activities.flatten)] }

        Then  { expect(find('header .navbar-nav')).to have_css("a[href=\"#{href}\"]", text: locator, visible: false) }
      end

      describe 'should not see it with all other activities' do
        Given { @user = create :person, roles: [create(:role, activities: (all_activities - activities.flatten))] }

        Then  { expect(find('header .navbar-nav')).not_to have_css("a[href=\"#{href}\"]", text: locator, visible: false) }
      end
    end
  end

  it_behaves_like :nav_links, I18n.t('defaults.links.groups')     , '#'                 , %w[academic_group:new academic_group:index]
  it_behaves_like :nav_links, I18n.t('defaults.links.group_add')  , '/academic_groups/new', 'academic_group:new'
  it_behaves_like :nav_links, I18n.t('defaults.links.groups_list'), '/academic_groups'    , 'academic_group:index'

  it_behaves_like :nav_links, I18n.t('defaults.links.people')     , '#'           , %w[person:new person:index]
  it_behaves_like :nav_links, I18n.t('defaults.links.person_add') , '/people/new' , 'person:new'
  it_behaves_like :nav_links, I18n.t('defaults.links.people_list'), '/people'     , 'person:index'
end
