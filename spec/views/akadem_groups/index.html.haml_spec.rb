# require 'rails_helper'

describe 'academic_groups/index' do
  Given(:models_count) { 20 }
  Given(:title) { I18n.t('academic_groups.index.title') }
  Given(:h1) { I18n.t('academic_groups.index.title') }
  Given(:row_class) { 'academic_group' }

  Given { models_count.times { create :academic_group } }
  Given { login_as_admin }

  When  { visit academic_groups_path }

  it_behaves_like 'index.html', [
    I18n.t('academic_groups.index.table_title_name'),
    I18n.t('academic_groups.index.table_title_established'),
    I18n.t('academic_groups.index.table_title_description')
  ]
end
