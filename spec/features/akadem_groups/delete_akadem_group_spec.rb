require 'spec_helper'

feature "Delete akadem group:", js: true do
  it_behaves_like :integration_delete_model, AkademGroup
end
