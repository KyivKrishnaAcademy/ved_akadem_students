require 'rails_helper'

describe :changelog do
  subject { page }

  When { visit changelog_path }

  Then { is_expected.to have_title I18n.t :application_title }
end
