require 'rails_helper'

describe Ui::CoursesController do
  it_behaves_like :ui_controller_index,
                  :index,
                  Ui::CoursesLoadingInteraction,
                  %w(class_schedule:edit class_schedule:new)
end
