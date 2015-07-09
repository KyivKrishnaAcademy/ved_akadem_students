class Ui::CoursesController < Ui::BaseController
  def index
    authorize Course, :ui_index?

    respond_with_interaction CoursesLoadingInteraction
  end
end
