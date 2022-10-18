module Ui
  class GroupAdminsLoadingInteraction < BaseInteraction
    include Peoplable

    def init
      @people = Person.ilike('complex_name', params[:q])
    end
  end
end
