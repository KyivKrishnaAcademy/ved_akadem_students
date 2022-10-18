module Ui
  class GroupPraepostorsLoadingInteraction < BaseInteraction
    include Peoplable

    def init
      @people = AcademicGroup.find(params[:group_id]).active_students.ilike('complex_name', params[:q])
    end
  end
end
