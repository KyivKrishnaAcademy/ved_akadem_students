require 'rails_helper'

describe Ui::CoursesController do
  it_behaves_like :ui_controller_index,
                  :index,
                  CoursesLoadingInteraction,
                  %w(class_schedule:edit class_schedule:new)
end
