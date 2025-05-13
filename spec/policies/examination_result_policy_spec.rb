# require 'rails_helper'
require 'pundit/rspec'

describe ExaminationResultPolicy do
  subject { ExaminationResultPolicy }

  Given(:user) { create(:person) }
  Given(:record) { create(:examination_result) }

  context 'given user\'s role activities' do
    %i(ui_create? ui_update? ui_destroy?).each do |action|
      permissions action do
        it_behaves_like :allow_with_activities, ['examination_result:' << action.to_s.sub('?', '')]
      end
    end
  end
end
