require "spec_helper"

describe "People routes" do
  let(:controller) { "people" }

  it_behaves_like "CRUD"
end
