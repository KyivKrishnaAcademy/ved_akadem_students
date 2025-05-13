# require 'rails_helper'

describe Ui::TeacherProfilesController do
  it_behaves_like :ui_controller_index,
                  :index,
                  Ui::TeacherProfilesLoadingInteraction,
                  %w(class_schedule:edit class_schedule:new course:edit course:new)
end
