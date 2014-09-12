require 'rails_helper'

describe ApplicationHelper do
  describe '#full_title' do
    it 'should include the page title and base title' do
      expect(full_title('foo')).to eq("#{t :application_title} | foo")
    end

    it 'should not include a bar for the home page' do
      expect(full_title('')).to eq("#{t :application_title}")
    end
  end
end
