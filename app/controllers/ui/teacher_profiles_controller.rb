class Ui::TeacherProfilesController < Ui::BaseController
  def index
    authorize TeacherProfile

    respond_with_interaction TeacherProfilesLoadingInteraction
  end
end
