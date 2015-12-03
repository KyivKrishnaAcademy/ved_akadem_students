require 'rails_helper'

describe 'certificate_templates/edit' do
  Given(:page) { Capybara::Node::Simple.new(response.body) }
  Given(:user) { create :person, roles: [role] }
  Given(:role) { create :role, activities: ['certificate_template:edit', "certificate_template:#{activity}"] }
  Given(:template) { create :certificate_template }

  Given do
    allow(view).to receive(:policy).with(CertificateTemplate)
                                   .and_return(CertificateTemplatePolicy.new(user, CertificateTemplate))
    allow(view).to receive(:policy).with(template)
                                   .and_return(CertificateTemplatePolicy.new(user, template))
    allow(view).to receive(:params).and_return({action: 'edit'})
  end

  Given { assign(:certificate_template, template) }
  Given { sign_in(user) }

  When  { render }

  describe 'conditional links' do
    Given(:new_link_selector) { "a[href='#{new_certificate_template_path}'] .glyphicon-file" }
    Given(:edit_link_selector) { "a[href='#{edit_certificate_template_path(template)}'] .glyphicon-pencil" }
    Given(:index_link_selector) { "a[href='#{certificate_templates_path}'] .glyphicon-list" }
    Given(:markup_link_selector) { "a[href='#{markup_certificate_template_path(template)}'] .glyphicon-picture" }
    Given(:destroy_link_selector) { "a[href='#{certificate_template_path(template)}'] .glyphicon-trash" }

    Given(:markup_link) { expect(page).to have_selector(markup_link_selector) }

    Given(:no_new_link) { expect(page).not_to have_selector(new_link_selector) }
    Given(:no_edit_link) { expect(page).not_to have_selector(edit_link_selector) }
    Given(:no_index_link) { expect(page).not_to have_selector(index_link_selector) }
    Given(:no_destroy_link) { expect(page).not_to have_selector(destroy_link_selector) }

    context 'without additional rights' do
      Given(:activity) { 'none' }

      Then { no_new_link }
      And  { markup_link }
      And  { no_edit_link }
      And  { no_index_link }
      And  { no_destroy_link }
    end

    context 'with :new rights' do
      Given(:activity) { 'new' }

      Then { expect(page).to have_selector(new_link_selector) }
      And  { markup_link }
      And  { no_edit_link }
      And  { no_index_link }
      And  { no_destroy_link }
    end

    context 'with :index rights' do
      Given(:activity) { 'index' }

      Then { expect(page).to have_selector(index_link_selector) }
      And  { no_new_link }
      And  { markup_link }
      And  { no_edit_link }
      And  { no_destroy_link }
    end

    context 'with :markup rights' do
      Given(:activity) { 'markup' }

      Then { expect(page).to have_selector(markup_link_selector) }
      And  { no_new_link }
      And  { no_edit_link }
      And  { no_index_link }
      And  { no_destroy_link }
    end

    context 'with :destroy rights' do
      Given(:activity) { 'destroy' }

      Then { expect(page).to have_selector(destroy_link_selector) }
      And  { no_new_link }
      And  { no_edit_link }
      And  { markup_link }
      And  { no_index_link }
    end
  end
end
