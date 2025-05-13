# require 'rails_helper'

describe 'Delete academic group:', :js do
  Given { login_as_admin }

  # TODO: fix and enable the test
  # > Could not find component registered with name AdvancedSearchApp. Registered component names include [  ].
  # > Maybe you forgot to register the component?
  # it_behaves_like :integration_delete_model, AcademicGroup
end
