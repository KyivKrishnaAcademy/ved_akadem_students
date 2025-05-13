# require 'rails_helper'
require_relative './shared/certificate_templates_context'

describe 'certificate_templates/index' do
  include_context :certificate_templates_context

  Given(:base_activity) { 'index' }

  Given { assign(:certificate_templates, [template]) }

  describe 'conditional links' do
    Given(:subject) { page.find('tbody tr', text: template.title) }
    Given(:no_new_link) { expect(page).not_to have_selector(new_link_selector) }

    context 'without additional rights' do
      Given(:activity) { 'none' }

      Then { no_new_link }
      And  { no_edit_link }
      And  { no_destroy_link }
    end

    context 'with :new rights' do
      Given(:activity) { 'new' }

      Then { expect(page).to have_selector(new_link_selector) }
      And  { no_edit_link }
      And  { no_destroy_link }
    end

    context 'with :edit rights' do
      Given(:activity) { 'edit' }

      Then { edit_link }
      And  { no_new_link }
      And  { no_destroy_link }
    end

    context 'with :destroy rights' do
      Given(:activity) { 'destroy' }

      Then { destroy_link }
      And  { no_new_link }
      And  { no_edit_link }
    end
  end
end
