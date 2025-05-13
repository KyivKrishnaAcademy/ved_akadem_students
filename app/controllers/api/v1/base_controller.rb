module Api
  module V1
    class BaseController < ApplicationController
      include Authenticable

      protect_from_forgery with: :null_session
      respond_to :json

      skip_before_action :set_locale

      attr_reader :current_person

      helper_method :current_person
    end
  end
end
