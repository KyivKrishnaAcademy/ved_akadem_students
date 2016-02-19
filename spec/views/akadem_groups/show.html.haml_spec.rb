require 'rails_helper'

describe 'academic_groups/show' do
  GROUP_ELDERS = %w(administrator curator praepostor)

  Given(:activities) { ['academic_group:show'] }
  Given(:ag_name) { 'ТВ99-1' }
  Given(:policy) { double(AcademicGroupPolicy) }
  Given(:group) { create :academic_group, { title: ag_name } }
  Given(:user) { create :person, roles: [create(:role, activities: activities)] }
  Given(:page) { Capybara::Node::Simple.new(response.body) }

  Given { login_as(user) }
  Given { assign(:academic_group, group) }
  Given { allow(view).to receive(:policy).with(group).and_return(AcademicGroupPolicy.new(user, group)) }
  Given { allow(view).to receive(:policy).with(user).and_return(PersonPolicy.new(user, user)) }
  Given { allow(view).to receive(:current_person).and_return(user) }

  When  { render }

  Given(:pdf_photos_link) { "a.glyphicon-print[href='#{group_list_pdf_path(group)}']" }
  Given(:pdf_attendance_link) { "a.glyphicon-print[href='#{attendance_template_pdf_path(group)}']" }

  describe 'common with restricted rights' do
    Then  { expect(rendered).to have_selector('h1', text: ag_name) }
    And   { expect(rendered).to have_text("#{I18n.t('activerecord.attributes.academic_group.establ_date')}: #{I18n.l(group.establ_date)}") }
    And   { expect(rendered).to have_text("#{I18n.t('activerecord.attributes.academic_group.group_description')}: #{group.group_description}") }

    And   { expect(rendered).not_to have_link(I18n.t('links.edit')) }
    And   { expect(rendered).not_to have_link(I18n.t('links.delete')) }
    And   { expect(rendered).not_to have_link(I18n.t('links.graduate')) }
    And   { expect(page).not_to have_css(pdf_photos_link) }
    And   { expect(page).not_to have_css(pdf_attendance_link) }

    And   { expect(rendered).not_to have_text(I18n.t('academic_groups.show.group_servants')) }

    And   { expect(rendered).not_to have_text(I18n.t('activerecord.attributes.academic_group.graduated_at')) }
  end

  describe 'group schedule', :js do
    subject { page.find('#schedules') }

    context 'no schedule' do
      Then { is_expected.to have_content(I18n.t('academic_groups.show.no_pending_schedules')) }
      And  { is_expected.not_to have_content(I18n.t('class_schedules.table_headers.time'))}
    end

    context 'some schedules' do
      Given { create :class_schedule, academic_groups: [group] }

      Then  { is_expected.to have_content(I18n.t('class_schedules.table_headers.time')) }
      And   { is_expected.not_to have_content(I18n.t('academic_groups.show.no_pending_schedules'))}
    end
  end

  describe 'with group_list_pdf rights' do
    Given(:activities) { %w(academic_group:show academic_group:group_list_pdf) }

    Then { expect(page).to have_css(pdf_photos_link) }
    And  { expect(page).not_to have_css(pdf_attendance_link) }
  end

  describe 'with group_list_pdf rights' do
    Given(:activities) { %w(academic_group:show academic_group:attendance_template_pdf) }

    Then { expect(page).to have_css(pdf_attendance_link) }
    And  { expect(page).not_to have_css(pdf_photos_link) }
  end

  describe 'with edit rights' do
    Given(:activities) { %w(academic_group:show academic_group:edit) }

    Then  { expect(rendered).to have_link(I18n.t('links.edit'))}
    And   { expect(rendered).not_to have_link(I18n.t('links.delete'))}
  end

  describe 'with destroy rights' do
    Given(:activities) { %w(academic_group:show academic_group:destroy) }

    Then  { expect(rendered).to have_link(I18n.t('links.delete'))}
    And   { expect(rendered).not_to have_link(I18n.t('links.edit'))}
  end

  describe 'has group elders' do
    GROUP_ELDERS.each do |elder|
      describe elder do
        Given { group.update_column("#{elder}_id", user.id) }

        Then  { expect(rendered).to have_text(I18n.t('academic_groups.show.group_servants')) }
        And   { expect(rendered).to have_text(I18n.t("academic_groups.show.#{elder}")) }
        And   { expect(rendered).to have_text(user.email) }

        (GROUP_ELDERS - [elder]).each do |missing_elder|
          And { expect(rendered).not_to have_text(I18n.t("academic_groups.show.#{missing_elder}")) }
        end
      end
    end
  end

  describe 'has group students list' do
    subject { page.find('#group_list table') }

    shared_examples_for :not_conditional_values do
      Then { is_expected.to have_content(I18n.l(user.birthday, format: :short)) }
    end

    shared_examples_for :group_list_table do |table_headers, table_no_headers|
      Then { is_expected.to have_selector('tbody tr', count: 1 ) }

      table_headers.each do |header|
        And { is_expected.to have_selector('th', text: header) }
      end

      table_no_headers.each do |header|
        And { is_expected.not_to have_selector('th', text: header) }
      end
    end

    Given { user.create_student_profile.move_to_group(group) }

    context 'regular student' do
      it_behaves_like :group_list_table, ['#', 'Фото', "Ім'я", 'День народження'], ['Телефони']
      it_behaves_like :not_conditional_values

      Then { is_expected.not_to have_content(user.telephones.first.phone) }
      And  { is_expected.not_to have_link(user.complex_name, person_path(user)) }
    end

    describe 'I am the group elder' do
      GROUP_ELDERS.each do |elder|
        Given { group.update_column("#{elder}_id", user.id) }

        context elder do
          it_behaves_like :group_list_table, ['#', 'Фото', "Ім'я", 'День народження', 'Телефони'], []
          it_behaves_like :not_conditional_values

          Then { is_expected.to have_content(user.telephones.first.phone) }
          And  { is_expected.not_to have_link(user.complex_name, person_path(user)) }
        end
      end
    end

    describe 'can see show_person link' do
      Given(:activities) { %w(academic_group:show person:show) }

      it_behaves_like :not_conditional_values

      Then { is_expected.to have_link(complex_name(user, true), person_path(user)) }
    end
  end

  describe 'graduated group' do
    Given { group.graduate! }

    describe 'date shown' do
      Then  { expect(rendered).to have_text(I18n.t('activerecord.attributes.academic_group.graduated_at')) }
      And   { expect(rendered).to have_text(I18n.l(group.graduated_at, format: :with_day)) }
    end

    describe 'graduate link hidden with valid rights' do
      Given(:activities) { %w(academic_group:graduate) }

      Then { expect(rendered).not_to have_link(I18n.t('links.graduate')) }
    end
  end

  describe 'graduate link' do
    Given(:activities) { %w(academic_group:graduate) }

    Then { expect(rendered).to have_link(I18n.t('links.graduate')) }
  end
end
