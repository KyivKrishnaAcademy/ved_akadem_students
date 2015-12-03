require 'rails_helper'
require_relative './shared/certificate_templates_context'

describe 'certificate_templates/markup' do
  include_context :certificate_templates_context

  Given(:role) { create :role, activities: ['certificate_template:markup', "certificate_template:#{activity}"] }

  Given { allow(view).to receive(:params).and_return({action: 'markup'}) }
  Given { assign(:certificate_template, template) }
  Given { sign_in(user) }

  When  { render }

  describe 'conditional links' do
    Given(:subject) { page }

    context 'without additional rights' do
      Given(:activity) { 'none' }

      Then { no_new_link }
      And  { no_edit_link }
      And  { no_index_link }
      And  { no_markup_link }
      And  { no_destroy_link }
    end

    context 'with :new rights' do
      Given(:activity) { 'new' }

      Then { expect(page).to have_selector(new_link_selector) }
      And  { no_edit_link }
      And  { no_index_link }
      And  { no_markup_link }
      And  { no_destroy_link }
    end

    context 'with :index rights' do
      Given(:activity) { 'index' }

      Then { expect(page).to have_selector(index_link_selector) }
      And  { no_new_link }
      And  { no_edit_link }
      And  { no_markup_link }
      And  { no_destroy_link }
    end

    context 'with :markup rights' do
      Given(:activity) { 'edit' }

      Then { expect(page).to have_selector(edit_link_selector) }
      And  { no_new_link }
      And  { no_index_link }
      And  { no_markup_link }
      And  { no_destroy_link }
    end

    context 'with :destroy rights' do
      Given(:activity) { 'destroy' }

      Then { expect(page).to have_selector(destroy_link_selector) }
      And  { no_new_link }
      And  { no_edit_link }
      And  { no_index_link }
      And  { no_markup_link }
    end
  end
end
