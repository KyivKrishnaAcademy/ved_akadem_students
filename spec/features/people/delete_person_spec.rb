require 'spec_helper'

feature "Delete person:", js: true do
  before do
    create_person username: 'test', password: 'password', password_confirmation: 'password'
    visit new_person_session_path
    fill_in 'person_username', with: 'test'
    fill_in 'person_password', with: 'password'
    click_button 'Sign in'
  end

  it_behaves_like :integration_delete_model, Person
end
