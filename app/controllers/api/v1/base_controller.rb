module Api
  module V1
    class BaseController < ApplicationController
      before_action :authenticate_person!

      protect_from_forgery with: :null_session

      respond_to :json

      skip_before_action :set_locale

      def current_person
        current_user
      end
    end
  end
end