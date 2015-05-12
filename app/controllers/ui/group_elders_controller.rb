class Ui::GroupEldersController < Ui::BaseController
  before_action :authorize_person

  def group_admins_index
    respond_with_interaction GroupAdminsLoadingInteraction
  end

  def group_curators_index
    respond_with_interaction GroupCuratorsLoadingInteraction
  end

  def group_praepostors_index
    respond_with_interaction GroupPraepostorsLoadingInteraction
  end

  private

  def authorize_person
    authorize Person
  end
end
