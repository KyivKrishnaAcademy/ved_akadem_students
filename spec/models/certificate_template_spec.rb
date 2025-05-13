# require 'rails_helper'

describe CertificateTemplate do
  describe 'validation' do
    Then { is_expected.to validate_presence_of(:title) }
  end
end
