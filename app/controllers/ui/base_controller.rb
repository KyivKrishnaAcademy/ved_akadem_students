class Ui::BaseController < ApplicationController
  respond_to :json

  skip_before_action :set_locale

  private

  def respond_with_interaction(klass)
    respond_with klass.new(user: current_person, request: request, params: params), location: false
  end

  def user_not_authorized
    render json: { error: :not_authorized }, status: 401
  end
end
