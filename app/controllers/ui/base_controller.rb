module Ui
  class BaseController < ApplicationController
    respond_to :json

    skip_before_action :set_locale

    private

    def user_not_authorized
      render json: { error: :not_authorized }, status: 401
    end
  end
end
