require 'rails_helper'

describe 'certificate_templates/index' do
  Given(:page) { Capybara::Node::Simple.new(response.body) }
  Given(:user) { create :person, roles: [role] }
  Given(:role) { create :role, activities: ['certificate_template:index', "certificate_template:#{activity}"] }
  Given(:template) { create :certificate_template }

  Given { allow(view).to receive(:policy).with(template)
                                         .and_return(CertificateTemplatePolicy.new(user, template)) }

  Given { assign(:certificate_templates, [template]) }
  Given { sign_in(user) }

  When  { render }

  describe 'conditional links' do
    Given(:row) { page.find('tbody tr', text: template.title) }
    Given(:new_link_selector) { "a[href='#{new_certificate_template_path}'] .glyphicon-file" }
    Given(:edit_link_selector) { "a[href='#{edit_certificate_template_path(template)}'] .glyphicon-pencil" }
    Given(:markup_link_selector) { "a[href='#{markup_certificate_template_path(template)}'] .glyphicon-picture" }
    Given(:destroy_link_selector) { "a[href='#{certificate_template_path(template)}'] .glyphicon-trash" }

    Given(:no_new_link) { expect(page).not_to have_selector(new_link_selector) }
    Given(:no_show_link) { expect(row).not_to have_link(template.title, href: certificate_template_path(template)) }
    Given(:no_edit_link) { expect(row).not_to have_selector(edit_link_selector) }
    Given(:no_markup_link) { expect(row).not_to have_selector(markup_link_selector) }
    Given(:no_destroy_link) { expect(row).not_to have_selector(destroy_link_selector) }

    context 'without additional rights' do
      Given(:activity) { 'none' }

      Then { no_new_link }
      And  { no_show_link }
      And  { no_edit_link }
      And  { no_markup_link }
      And  { no_destroy_link }
    end

    context 'with :new rights' do
      Given(:activity) { 'new' }

      Then { expect(page).to have_selector(new_link_selector) }
      And  { no_show_link }
      And  { no_edit_link }
      And  { no_markup_link }
      And  { no_destroy_link }
    end

    context 'with :edit rights' do
      Given(:activity) { 'edit' }

      Then { expect(row).to have_selector(edit_link_selector) }
      And  { no_new_link }
      And  { no_show_link }
      And  { expect(row).to have_selector(markup_link_selector) }
      And  { no_destroy_link }
    end

    context 'with :destroy rights' do
      Given(:activity) { 'destroy' }

      Then { expect(page).to have_selector(destroy_link_selector) }
      And  { no_show_link }
      And  { no_edit_link }
      And  { no_markup_link }
      And  { no_new_link }
    end

    context 'with :show rights' do
      Given(:activity) { 'show' }

      Then { expect(row).to have_link(template.title, href: certificate_template_path(template)) }
      And  { no_new_link }
      And  { no_edit_link }
      And  { no_markup_link }
      And  { no_destroy_link }
    end
  end
end
