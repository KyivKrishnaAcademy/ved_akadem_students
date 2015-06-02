class Ui::ClassroomsController < Ui::BaseController
  def index
    authorize Classroom, :ui_index?

    respond_with_interaction ClassroomsLoadingInteraction
  end
end
