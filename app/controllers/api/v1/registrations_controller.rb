module Api
  module V1
    class RegistrationsController < Devise::RegistrationsController
      respond_to :json

      private

      def respond_with(resource, _opts = {})
        if resource.persisted?
          render json: { message: 'Signed up successfully', user: resource }, status: :ok
        else
          render json: { message: "Sign up failed", errors: resource.errors.full_messages }, status: :unprocessable_entity
        end
      end
    end
  end
end