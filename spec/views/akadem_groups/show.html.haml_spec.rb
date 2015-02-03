require 'rails_helper'

describe 'akadem_groups/show' do
  Given(:ag_name) { 'ТВ99-1' }
  Given(:policy) { double(AkademGroupPolicy) }
  Given(:group) { create :akadem_group, { group_name: ag_name } }
  Given(:user) { create :person }

  Given { login_as(user) }
  Given { assign(:akadem_group, group) }
  Given { allow(view).to receive(:policy).with(group).and_return(policy) }
  Given { allow(policy).to receive(:edit?).and_return(false) }
  Given { allow(policy).to receive(:destroy?).and_return(false) }

  When  { render }
#TODO
  describe 'common with restricted rights' do
    Then  { expect(rendered).to have_selector('h1', text: ag_name) }
    And   { expect(rendered).to have_text("#{I18n.t('activerecord.attributes.akadem_group.establ_date')}: #{group.establ_date.to_s}") }
    And   { expect(rendered).to have_text("#{I18n.t('activerecord.attributes.akadem_group.group_description')}: #{group.group_description}") }

    And   { expect(rendered).not_to have_link(I18n.t('links.edit'))}
    And   { expect(rendered).not_to have_link(I18n.t('links.delete'))}

    And   { expect(rendered).not_to have_text(I18n.t('akadem_groups.show.group_servants')) }
  end

  describe 'with edit rights' do
    Given { allow(policy).to receive(:edit?).and_return(true) }

    Then  { expect(rendered).to have_link(I18n.t('links.edit'))}
    And   { expect(rendered).not_to have_link(I18n.t('links.delete'))}
  end

  describe 'with destroy rights' do
    Given { allow(policy).to receive(:destroy?).and_return(true) }

    Then  { expect(rendered).to have_link(I18n.t('links.delete'))}
    And   { expect(rendered).not_to have_link(I18n.t('links.edit'))}
  end

  describe 'has group elders' do
    group_elders = %w[administrator curator praepostor]

    group_elders.each do |elder|
      describe elder do
        Given { group.update_column("#{elder}_id", user.id) }

        Then  { expect(rendered).to have_text(I18n.t('akadem_groups.show.group_servants')) }
        And   { expect(rendered).to have_text(I18n.t("akadem_groups.show.#{elder}")) }
        And   { expect(rendered).to have_text(user.email) }

        (group_elders - [elder]).each do |missing_elder|
          And { expect(rendered).not_to have_text(I18n.t("akadem_groups.show.#{missing_elder}")) }
        end
      end
    end
  end
end
