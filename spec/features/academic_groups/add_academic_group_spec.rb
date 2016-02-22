require 'rails_helper'

describe 'Add academic group:' do
  before do
    login_as_admin
    visit new_academic_group_path
  end

  let(:fill_right) { fill_academic_group_data }
  let(:fill_wrong) { fill_academic_group_data title: '12-1' }
  let(:model)      { AcademicGroup }
  let(:attr_name)  { :title }
  let(:locator)    { "#{the_m.title}" }

  it_behaves_like :adds_model
  it_behaves_like :not_adds_model
  it_behaves_like :link_in_flash

  describe 'select elders', :js do
    Given(:person) { create :person }
    Given(:curator_container) { find('.academic_group_curator span.select2-container') }
    Given(:administrator_container) { find('.academic_group_administrator span.select2-container') }

    Given(:selected_person) { "span.select2-selection__rendered[title='#{person.complex_name}']" }

    Given { person.create_teacher_profile }

    When  { fill_right }
    When  { curator_container.click }
    When  { find('#select2-academic_group_curator_id-results li.select2-results__option', text: person.complex_name).click }
    When  { administrator_container.click }
    When  { find('#select2-academic_group_administrator_id-results li.select2-results__option', text: person.complex_name).click }

    Then  { expect(curator_container).to have_selector(selected_person) }
    And   { expect(administrator_container).to have_selector(selected_person) }
    And   { expect(find('.academic_group_praepostor')).to have_selector('span.select2-container--disabled') }
    And   { click_button 'Створити Academic group' }
    And   { expect(page).to have_selector('.alert-success') }
    And   { visit academic_group_path(AcademicGroup.last) }
    And   { expect(find('.tab-pane#general tr', text: I18n.t('academic_groups.show.curator'))).to have_content(person.spiritual_name) }
    And   { expect(find('.tab-pane#general tr', text: I18n.t('academic_groups.show.administrator'))).to have_content(person.spiritual_name) }
  end

  def fill_academic_group_data ag={}
    agf = build(:academic_group, ag)
    fill_in 'academic_group_title', with: (agf.title)
    fill_in 'academic_group_group_description', with: (agf.group_description)
    select (ag[:establ_date_1i]||'2015').to_s, from: 'academic_group_establ_date_1i'
    select (ag[:establ_date_2i]||'Вересня').to_s, from: 'academic_group_establ_date_2i'
    select (ag[:establ_date_3i]||'29').to_s, from: 'academic_group_establ_date_3i'
    agf
  end
end
