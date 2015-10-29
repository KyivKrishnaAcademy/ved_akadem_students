module Ui
  class PeopleController < Ui::BaseController
    def move_to_group
      authorize Person.find(params.require(:id))

      respond_with_interaction Ui::PersonGroupUpdatingInteraction
    end
  end
end
