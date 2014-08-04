require 'spec_helper'

feature "Delete akadem group:", :js do
  it_behaves_like :integration_delete_model, AkademGroup
end
