class Api::V1::PeopleController < Api::V1::ApplicationController
  def index
    respond_with_interaction Api::PeopleLoadingInteraction
  end
end
