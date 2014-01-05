require 'spec_helper'

feature "Delete person:", js: true do
  it_behaves_like :integration_delete_model, Person
end
