module Ui
  class GroupCuratorsLoadingInteraction < BaseInteraction
    include Peoplable

    def init
      @people = Person.joins(:teacher_profile).ilike('complex_name', params[:q])
    end
  end
end
