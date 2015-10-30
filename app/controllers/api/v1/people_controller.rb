module Api
  module V1
    class PeopleController < Api::V1::ApplicationController
      def index
        respond_with_interaction Api::PeopleLoadingInteraction
      end
    end
  end
end
