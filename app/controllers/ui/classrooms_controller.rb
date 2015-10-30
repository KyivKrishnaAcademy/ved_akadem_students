module Ui
  class ClassroomsController < Ui::BaseController
    def index
      authorize Classroom, :ui_index?

      respond_with_interaction Ui::ClassroomsLoadingInteraction
    end
  end
end
