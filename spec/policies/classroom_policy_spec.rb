require 'rails_helper'
require 'pundit/rspec'

describe ClassroomPolicy do
  subject { ClassroomPolicy }

  let(:user) { create(:person) }

  context 'complex conditions' do
    it_behaves_like :class_schedule_ui_index
  end
end
