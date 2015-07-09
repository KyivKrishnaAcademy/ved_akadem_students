require 'rails_helper'

describe Ui::ClassroomsController do
  it_behaves_like :ui_controller_index,
                  :index,
                  ClassroomsLoadingInteraction,
                  %w(class_schedule:edit class_schedule:new)
end
