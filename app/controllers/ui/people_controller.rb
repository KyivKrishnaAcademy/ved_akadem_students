module Ui
  class PeopleController < Ui::BaseController
    include PersonSetable
    include ClassSchedulesRefreshable

    before_action :set_person, only: %i[move_to_group]

    after_action :verify_authorized, :verify_policy_scoped, :refresh_class_schedules_mv

    def move_to_group
      respond_with_interaction Ui::PersonGroupUpdatingInteraction, @person
    end
  end
end
