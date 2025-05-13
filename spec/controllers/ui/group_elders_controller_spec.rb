# require 'rails_helper'

describe Ui::GroupEldersController do
  PERMITTED_ACTIVITIES = %w(academic_group:edit academic_group:new).freeze

  it_behaves_like :ui_controller_index,
                  :group_admins_index,
                  Ui::GroupAdminsLoadingInteraction,
                  PERMITTED_ACTIVITIES

  it_behaves_like :ui_controller_index,
                  :group_curators_index,
                  Ui::GroupCuratorsLoadingInteraction,
                  PERMITTED_ACTIVITIES

  it_behaves_like :ui_controller_index,
                  :group_praepostors_index,
                  Ui::GroupPraepostorsLoadingInteraction,
                  PERMITTED_ACTIVITIES
end
