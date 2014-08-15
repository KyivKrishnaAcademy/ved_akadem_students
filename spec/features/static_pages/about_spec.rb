require 'spec_helper'

describe :about do
  it 'should have the right title' do
    visit '/static_pages/about'
    expect(page).to have_title("#{I18n.t :application_title} | About")
  end
end
