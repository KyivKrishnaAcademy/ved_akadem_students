require 'rails_helper'
require_relative './shared/certificate_templates_context'

describe 'certificate_templates/new' do
  include_context :certificate_templates_context

  Given(:base_activity) { 'new' }

  Given { assign(:certificate_template, CertificateTemplate.new) }

  describe 'conditional links' do
    Given(:subject) { page }

    context 'without additional rights' do
      Given(:activity) { 'none' }

      Then { no_index_link }
    end

    context 'with :index rights' do
      Given(:activity) { 'index' }

      Then { index_link }
    end
  end
end
