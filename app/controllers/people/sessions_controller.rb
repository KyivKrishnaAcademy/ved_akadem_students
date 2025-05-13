class People::SessionsController < Devise::SessionsController
  respond_to :html, :json
  skip_before_action :verify_authenticity_token

  def new
    super
  end

  private

  def respond_with(resource, _opts = {})
    respond_to do |format|
      format.html { super }
      format.json { render json: { token: request.env['warden-jwt_auth.token'], person: resource }, status: :ok }
    end
  end

  def respond_to_on_destroy
    current_person ? head(:no_content) : render(json: { error: 'Not logged in' }, status: :unauthorized)
  end
end
