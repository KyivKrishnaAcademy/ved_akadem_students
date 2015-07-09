require 'rails_helper'

describe 'academic_groups/index' do
  Given(:models_count) { 20 }
  Given(:title)        { 'All Academic Groups' }
  Given(:h1)           { 'Academic Groups' }
  Given(:row_class)    { 'academic_group' }

  Given { models_count.times { create :academic_group } }
  Given { login_as_admin }

  When  { visit academic_groups_path }

  it_behaves_like 'index.html', ['Name', 'Established', 'Description']
end
