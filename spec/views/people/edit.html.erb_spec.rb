require 'spec_helper'

describe "people/edit.html.erb" do
  before do
    @p = create_person
    visit edit_person_path(@p)
  end

  after(:all) { Person.destroy_all }

  subject { page }

  let(:title)  { complex_name(@p, :t) }
  let(:h1)     { complex_name(@p) }
  let(:action) { 'edit' }

  it_behaves_like "person new and edit"
end
