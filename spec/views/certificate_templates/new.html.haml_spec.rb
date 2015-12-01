require 'rails_helper'

describe 'certificate_templates/new' do
  Given(:page) { Capybara::Node::Simple.new(response.body) }
  Given(:user) { create :person, roles: [role] }
  Given(:role) { create :role, activities: ['certificate_template:new', "certificate_template:#{activity}"] }

  Given do
    allow(view).to receive(:policy).with(CertificateTemplate)
                                   .and_return(CertificateTemplatePolicy.new(user, CertificateTemplate))
  end

  Given { assign(:certificate_template, CertificateTemplate.new) }
  Given { sign_in(user) }

  When  { render }

  describe 'conditional links' do
    Given(:index_link_selector) { "a[href='#{certificate_templates_path}'] .glyphicon-list" }

    context 'without additional rights' do
      Given(:activity) { 'none' }

      Then { expect(page).not_to have_selector(index_link_selector) }
    end

    context 'with :index rights' do
      Given(:activity) { 'index' }

      Then { expect(page).to have_selector(index_link_selector) }
    end
  end
end
