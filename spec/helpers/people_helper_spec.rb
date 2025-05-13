# require 'rails_helper'

describe PeopleHelper do
  describe 'not_adult_warning' do
    Then { expect(not_adult_warning(17.years.ago.to_date)).to be_blank }

    Then { expect(not_adult_warning(15.years.ago.to_date)).to have_content(I18n.t('people.show.not_adult')) }
  end
end
