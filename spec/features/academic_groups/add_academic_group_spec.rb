require 'rails_helper'

describe 'Add academic group:', :js do
  Given(:filled_right) { fill_academic_group_data }
  Given(:person) { create :person }

  Given { person.create_teacher_profile }

  When { login_as_admin }
  When { visit new_academic_group_path }
  When { filled_right }

  describe 'does not create the group' do
    When { click_button 'Створити Група' }

    Then { expect(page).to have_selector('.alert-danger ul li') }
  end

  describe 'creates the group' do
    Given(:administrator_container) { find('.academic_group_administrator span.select2-container') }
    Given(:curator_container) { find('.academic_group_curator span.select2-container') }
    Given(:selected_person) { "span.select2-selection__rendered[title='#{person.complex_name}']" }

    When { administrator_container.click }

    When do
      find(
        '#select2-academic_group_administrator_id-results li.select2-results__option',
        text: person.complex_name
      ).click
    end

    describe 'selectors have right values' do
      Then { expect(administrator_container).to have_selector(selected_person) }
      And  { expect(curator_container).not_to have_selector(selected_person) }
      And  { expect(find('.academic_group_praepostor')).to have_selector('span.select2-container--disabled') }
    end

    context 'create is clicked' do
      When { click_button 'Створити Група' }

      describe 'has right flash' do
        Then do
          expect(find('.alert-success')).to have_link(
            filled_right.title,
            href: academic_group_path(AcademicGroup.find_by(title: filled_right.title))
          )
        end
        And { expect(page).not_to have_selector('.alert-danger ul li') }
      end

      describe 'curator and administrator saved' do
        When { visit academic_group_path(AcademicGroup.last) }

        Then { expect(find('.tab-pane#general')).not_to have_css('tr', text: I18n.t('academic_groups.show.curator')) }

        And do
          expect(find('.tab-pane#general tr', text: I18n.t('academic_groups.show.administrator'))).to have_content(
            "#{person.surname} #{person.name}"
          )
        end
      end
    end

    describe 'with curator' do
      When { curator_container.click }

      When do
        find('#select2-academic_group_curator_id-results li.select2-results__option', text: person.complex_name).click
      end

      describe 'selectors have right values' do
        Then { expect(curator_container).to have_selector(selected_person) }
      end

      context 'create is clicked' do
        When { click_button 'Створити Група' }
        When { visit academic_group_path(AcademicGroup.last) }

        Then do
          expect(find('.tab-pane#general tr', text: I18n.t('academic_groups.show.curator'))).to have_content(
            "#{person.surname} #{person.name}"
          )
        end

        And do
          expect(find('.tab-pane#general tr', text: I18n.t('academic_groups.show.administrator'))).to have_content(
            "#{person.surname} #{person.name}"
          )
        end
      end
    end
  end

  def fill_academic_group_data(ag = {})
    agf = build(:academic_group, ag)

    fill_in 'academic_group_title', with: agf.title
    fill_in 'academic_group_group_description', with: agf.group_description

    select (ag[:establ_date_1i] || '2019').to_s, from: 'academic_group_establ_date_1i'
    select (ag[:establ_date_2i] || 'Вересня').to_s, from: 'academic_group_establ_date_2i'
    select (ag[:establ_date_3i] || '29').to_s, from: 'academic_group_establ_date_3i'

    agf
  end
end
