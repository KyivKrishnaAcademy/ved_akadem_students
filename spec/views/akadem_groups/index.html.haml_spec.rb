require 'spec_helper'

describe 'akadem_groups/index' do
  Given(:models_count) { 20 }
  Given(:title)        { 'All Akadem Groups' }
  Given(:h1)           { 'Akadem Groups' }
  Given(:row_class)    { 'akadem_group' }

  Given { models_count.times { create :akadem_group } }

  When  { visit akadem_groups_path }

  it_behaves_like 'index.html', ['Name', 'Estbalished', 'Description']
end
