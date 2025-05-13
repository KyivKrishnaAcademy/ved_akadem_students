# require 'rails_helper'

describe 'RBAC links visibility' do
  URL_HELPERS = Rails.application.routes.url_helpers

  shared_examples :nav_links do |locator, href, *activities|
    context "with activities #{activities.flatten.inspect}" do
      When { login_as(user) }
      When { visit '/' }

      describe "should see link '#{locator}' href: #{href}" do
        Given(:user) { create :person, roles: [create(:role, activities: activities.flatten)] }

        Then { expect(find('.sidebar')).to have_css("a[href=\"#{href}\"]", text: locator, visible: false) }
      end

      describe 'should not see it with all other activities' do
        Given(:user) { create :person, roles: [create(:role, activities: (all_activities - activities.flatten))] }

        Then do
          expect(find('.sidebar')).not_to have_css("a[href=\"#{href}\"]", text: locator, visible: false)
        end
      end
    end
  end

  %w(academic_group person course class_schedule certificate_template).each do |model|
    include_examples(
      :nav_links,
      I18n.t("defaults.links.#{model.pluralize}_add"),
      "/#{model.pluralize}/new",
      "#{model}:new"
    )

    include_examples(
      :nav_links,
      I18n.t("defaults.links.#{model.pluralize}_list"),
      "/#{model.pluralize}",
      "#{model}:index"
    )
  end

  include_examples(
    :nav_links,
    I18n.t('defaults.links.journal'),
    URL_HELPERS.journal_path,
    %w(paper_trail/version:show)
  )
end
