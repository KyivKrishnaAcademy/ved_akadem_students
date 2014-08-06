require 'spec_helper'

describe 'people/index' do
  Given(:models_count)  { 20 }
  Given(:title)         { 'All People' }
  Given(:h1)            { 'People' }
  Given(:row_class)     { 'person' }

  Given { models_count.times { create :person } }
  Given { login_as_admin }

  When  { visit people_path }

  it_behaves_like 'index.html', ['Name', 'Surname', 'Spiritual Name']
end
