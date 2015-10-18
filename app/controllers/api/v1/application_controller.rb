class Api::V1::ApplicationController < ApplicationController
  include DeviseTokenAuth::Concerns::SetUserByToken

  protect_from_forgery with: :null_session

  respond_to :json

  skip_before_action :set_locale

  alias_method :current_person, :current_api_v1_person
end
