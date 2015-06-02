class Ui::AcademicGroupsController < Ui::BaseController
  def index
    authorize AcademicGroup, :ui_index?

    respond_with_interaction AcademicGroupsLoadingInteraction
  end
end
