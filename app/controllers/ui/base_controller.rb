module Ui
  class BaseController < ApplicationController
    respond_to :json

    skip_before_action :set_locale
    skip_before_action :ensure_registration_complete

    private

    def user_not_authorized
      render json: { error: :not_authorized }, status: :unauthorized
    end

    def respond_with_interaction(klass, resource = nil)
      interaction = klass.new(user: current_person, params: params, resource: resource)

      render json: interaction, status: interaction.try(:status) || :ok
    end
  end
end
