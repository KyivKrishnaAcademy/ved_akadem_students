module Ui
  class ExaminationResultsController < Ui::BaseController
    before_action :set_resource, only: [:update, :destroy]

    def create
      resource = ExaminationResult.new(create_params)

      authorize resource, :ui_create?

      respond_with_interaction Ui::ExaminationResultUpdatingInteraction, resource
    end

    def update
      @resource.assign_attributes(update_params)

      authorize @resource, :ui_update?

      respond_with_interaction Ui::ExaminationResultUpdatingInteraction, @resource
    end

    def destroy
      authorize @resource, :ui_destroy?

      respond_with_interaction Ui::ExaminationResultDestroyingInteraction, @resource
    end

    private

    def create_params
      params.permit(:score, :examination_id, :student_profile_id)
    end

    def update_params
      params.permit(:score)
    end

    def set_resource
      @resource = ExaminationResult.find(params[:id])
    end
  end
end
