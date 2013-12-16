require 'spec_helper'

describe AkademGroupsController do
  before(:all) { 5.times { create_akadem_group } }
  after(:all) { AkademGroup.destroy_all }

  it_behaves_like "POST 'create'", :akadem_group , AkademGroup
  it_behaves_like "GET"          , :akadem_group , AkademGroup, :new
  it_behaves_like "GET"          , :akadem_group , AkademGroup, :show
  it_behaves_like "GET"          , :akadem_group , AkademGroup, :edit
  it_behaves_like "GET"          , :akadem_groups, AkademGroup, :index
  it_behaves_like "DELETE 'destroy'", AkademGroup
  it_behaves_like "PATCH 'update'", AkademGroup, :group_description

  let(:mod_params) do
    {
      group_name:        "ШБ13-5",
      establ_date:       3600.days.ago.to_date,
      group_description: "Харе Кришна Харе Кришна Кришна Кришна Харе Харе"
    }
  end

  it_behaves_like "controller subclass", AkademGroupsController::AkademGroupParams, :akadem_group
end
