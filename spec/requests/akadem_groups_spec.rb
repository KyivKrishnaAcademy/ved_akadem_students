require 'spec_helper'

describe "AkademGroups" do
  it_behaves_like "renders _form on New and Edit pages" do
    let(:new_path) { new_akadem_group_path }
    let(:edit_path) { edit_akadem_group_path(create(:akadem_group)) }
  end
end
