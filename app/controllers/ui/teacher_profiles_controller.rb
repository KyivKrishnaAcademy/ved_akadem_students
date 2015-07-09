class Ui::TeacherProfilesController < Ui::BaseController
  def index
    authorize TeacherProfile, :ui_index?

    respond_with_interaction TeacherProfilesLoadingInteraction
  end
end
