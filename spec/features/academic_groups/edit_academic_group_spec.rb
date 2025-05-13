# require 'rails_helper'

describe 'Edit academic group:' do
  Given(:academic_group) { create :academic_group }
  Given(:model_name_locale) { I18n.t('activerecord.models.academic_group') }
  Given(:click_save) { click_button I18n.t('academic_groups.edit.submit') }

  Given(:expect_to_flash_success) do
    expect(find('body')).to(
      have_selector(
        '.alert-success',
        text: I18n.t(
          'flash.academic_groups.update.success_html',
          resource_name: model_name_locale,
          link_or_name: academic_group.reload.title
        )
      )
    )
  end

  When { login_as_admin }
  When { visit edit_academic_group_path(academic_group) }

  describe 'select elders', :js do
    Given(:prev_person) { create :person }
    Given(:curator_container) { find('.academic_group_curator span.select2-container') }
    Given(:praepostor_container) { find('.academic_group_praepostor span.select2-container') }
    Given(:administrator_container) { find('.academic_group_administrator span.select2-container') }

    Given do
      academic_group
        .update_columns(
          curator_id: prev_person.id,
          praepostor_id: prev_person.id,
          administrator_id: prev_person.id
        )
    end

    describe 'previous person seleced' do
      Given(:selected_person) { "span.select2-selection__rendered[title='#{prev_person.complex_name}']" }

      Then { expect(curator_container).to have_selector(selected_person) }
      And  { expect(praepostor_container).to have_selector(selected_person) }
      And  { expect(administrator_container).to have_selector(selected_person) }
    end

    describe 'select new person' do
      Given(:person) { create :person }
      Given(:selected_person) { "span.select2-selection__rendered[title='#{person.complex_name}']" }

      Given { person.create_teacher_profile }
      Given { person.create_student_profile.move_to_group(academic_group) }

      When  { curator_container.click }

      When do
        find('#select2-academic_group_curator_id-results li.select2-results__option', text: person.complex_name)
          .click
      end

      When { praepostor_container.click }

      When do
        find('#select2-academic_group_praepostor_id-results li.select2-results__option', text: person.complex_name)
          .click
      end

      When { administrator_container.click }

      When do
        find('#select2-academic_group_administrator_id-results li.select2-results__option', text: person.complex_name)
          .click
      end

      Then  { expect(curator_container).to have_selector(selected_person) }
      And   { expect(praepostor_container).to have_selector(selected_person) }
      And   { expect(administrator_container).to have_selector(selected_person) }
      And   { click_save }
      And   { expect(page).to have_selector('.alert-success') }

      And do
        expect(find('.tab-pane#general tr', text: I18n.t('academic_groups.show.curator')))
          .to have_content("#{person.surname} #{person.name}")
      end

      And do
        expect(find('.tab-pane#general tr', text: I18n.t('academic_groups.show.praepostor')))
          .to have_content("#{person.surname} #{person.name}")
      end

      And do
        expect(find('.tab-pane#general tr', text: I18n.t('academic_groups.show.administrator')))
          .to have_content("#{person.surname} #{person.name}")
      end
    end
  end

  describe 'When values are valid:' do
    [
      {
        field: I18n.t('activerecord.attributes.academic_group.title'),
        value: ' бш99-9 ',
        test_field: 'БШ99-9'
      },
      {
        field: I18n.t('activerecord.attributes.academic_group.group_description'),
        value: 'Зис из э test',
        test_field: "#{I18n.t('activerecord.attributes.academic_group.group_description')}: Зис из э test"
      }
    ].each do |h|
      describe "valid fill in #{h[:field]}" do
        When { fill_in h[:field], with: h[:value] }
        When { click_save }

        Then { expect(find('body')).to have_text(h[:test_field]) }
        And  { expect_to_flash_success }
      end
    end

    describe 'Establishment date' do
      Given(:date) { '27.05.2019' }

      When { fill_in I18n.t('activerecord.attributes.academic_group.establ_date'), with: date }
      When { click_save }

      Then do
        expect(find('body')).to have_content("#{I18n.t('activerecord.attributes.academic_group.establ_date')}: #{date}")
      end

      And { expect_to_flash_success }
    end
  end

  describe 'add courses', :js do
    Given(:course) { create :course }

    When { select2_multi('academic_group_courses', course.title) }
    When { click_save }

    Then { expect_to_flash_success }
    And  { expect(academic_group.reload.course_ids).to eq([course.id]) }
  end
end
