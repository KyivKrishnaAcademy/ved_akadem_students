require 'rails_helper'

describe 'people/new.html.erb' do
  before do
    login_as_admin
    visit new_person_path
  end

  subject { page }

  let(:title)  { 'Add New Person' }
  let(:h1)     { 'Add Person' }
  let(:action) { 'new' }

  it_behaves_like 'person new and edit'
end
