module Ui
  class CoursesController < Ui::BaseController
    def index
      authorize Course, :ui_index?

      respond_with_interaction Ui::CoursesLoadingInteraction
    end
  end
end
