require 'rails_helper'
require_relative './shared/certificate_templates_context'

describe 'certificate_templates/markup' do
  include_context :certificate_templates_context

  Given(:base_activity) { 'markup' }

  Given { allow(view).to receive(:params).and_return(action: 'markup') }
  Given { assign(:certificate_template, template) }

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

      Then { new_link }
      And  { no_edit_link }
      And  { no_index_link }
      And  { no_markup_link }
      And  { no_destroy_link }
    end

    context 'with :index rights' do
      Given(:activity) { 'index' }

      Then { index_link }
      And  { no_new_link }
      And  { no_edit_link }
      And  { no_markup_link }
      And  { no_destroy_link }
    end

    context 'with :markup rights' do
      Given(:activity) { 'edit' }

      Then { edit_link }
      And  { no_new_link }
      And  { no_index_link }
      And  { no_markup_link }
      And  { no_destroy_link }
    end

    context 'with :destroy rights' do
      Given(:activity) { 'destroy' }

      Then { destroy_link }
      And  { no_new_link }
      And  { no_edit_link }
      And  { no_index_link }
      And  { no_markup_link }
    end
  end
end
