require 'spec_helper'

describe "people/edit.html.erb" do
  before do
    @p = create_person
    visit edit_person_path(@p)
  end

  subject { page }

  it { should have_title(full_title(complex_name(@p, :t))) }
  it { should have_selector('h1', text: complex_name(@p)) }
  it { should have_selector('form.edit_person') }

  it_behaves_like "person form"
end
