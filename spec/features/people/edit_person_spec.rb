require 'rails_helper'

describe 'Edit person:' do
  subject { page }

  before do
    login_as_admin
    visit person_path(create(:person, birthday: '2008-10-08'))
    click_link 'Edit'
  end

  context 'When values are valid:' do
    [
      { field: I18n.t('simple_form.labels.defaults.spiritual_name')   , value: 'AdiDasa dasa'  , test_field: 'Spiritual name: Adidasa Dasa' },
      { field: I18n.t('simple_form.labels.defaults.name')             , value: 'алексей'       , test_field: 'Name: Алексей'                },
      { field: I18n.t('simple_form.labels.defaults.middle_name')      , value: 'иванович'      , test_field: 'Middle name: Иванович'        },
      { field: I18n.t('simple_form.labels.defaults.surname')          , value: 'евгеньев'      , test_field: 'Surname: Евгеньев'            },
      { field: I18n.t('simple_form.labels.defaults.email')            , value: 'alex@PAMHO.net', test_field: 'Email: alex@pamho.net'        },
      { field: I18n.t('simple_form.labels.defaults.phone')            , value: '380692223344'  , test_field: 'Telephone 1: 380692223344'    },
      { field: 'person[edu_and_work]', value: 'some'      , test_field: 'Education, hobby, job: some'  },
      { field: I18n.t('simple_form.labels.defaults.emergency_contact'), value: 'дядя Петя'     , test_field: 'Emergency contact: дядя Петя' }
    ].each do |h|
      it_behaves_like :valid_fill_in, h, 'Person'
    end

    describe 'Birthday' do
      When { fill_in 'person[birthday]', with: '27.05.1985' }
      When { click_button 'Update Person' }

      describe 'brithdate is shown' do
        Then { expect(find('body')).to have_content('Birthday: 1985-05-27') }
      end

      it_behaves_like :alert_success_updated, 'Person'
    end

    describe 'Gender' do
      it_behaves_like :valid_select, 'Person', I18n.t('simple_form.labels.defaults.gender'), 'Male'  , 'Gender: Male'
      it_behaves_like :valid_select, 'Person', I18n.t('simple_form.labels.defaults.gender'), 'Female', 'Gender: Female'
    end
  end

  context 'When values are invalid:' do
    [
      { field: I18n.t('simple_form.labels.defaults.phone')  , value: '501112233' },
      { field: I18n.t('simple_form.labels.defaults.email')  , value: '@@.com@' },
      { field: I18n.t('simple_form.labels.defaults.name')   , value: '' },
      { field: I18n.t('simple_form.labels.defaults.surname'), value: '' }
    ].each do |h|
      describe h[:field] do
        When do
          fill_in(h[:field], with: h[:value])
          click_button('Update Person')
        end

        Then { expect(find('body')).to have_selector('.alert-danger') }
        And  { expect(find('.has-error')).to have_selector('span.help-block') }
      end
    end
  end
end
