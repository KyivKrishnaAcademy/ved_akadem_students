require 'rails_helper'

describe Ui::AcademicGroupsController do
  it_behaves_like :ui_controller_index,
                  :index,
                  AcademicGroupsLoadingInteraction,
                  %w(class_schedule:edit class_schedule:new)
end
