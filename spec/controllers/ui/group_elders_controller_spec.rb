require 'rails_helper'

describe Ui::GroupEldersController do
  PERMITTED_ACTIVITIES = %w(academic_group:edit academic_group:new)

  it_behaves_like :ui_controller_index,
                  :group_admins_index,
                  GroupAdminsLoadingInteraction,
                  PERMITTED_ACTIVITIES

  it_behaves_like :ui_controller_index,
                  :group_curators_index,
                  GroupCuratorsLoadingInteraction,
                  PERMITTED_ACTIVITIES

  it_behaves_like :ui_controller_index,
                  :group_praepostors_index,
                  GroupPraepostorsLoadingInteraction,
                  PERMITTED_ACTIVITIES
end
