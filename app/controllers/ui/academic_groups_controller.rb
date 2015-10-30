module Ui
  class AcademicGroupsController < Ui::BaseController
    def index
      authorize AcademicGroup, :ui_index?

      respond_with_interaction Ui::AcademicGroupsLoadingInteraction
    end
  end
end
