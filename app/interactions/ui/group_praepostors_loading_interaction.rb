module Ui
  class GroupPraepostorsLoadingInteraction < BaseInteraction
    include Peoplable

    def init
      #TODO replace this when ElasticSearch appears
      @people = AcademicGroup.find(params[:group_id]).active_students.where('complex_name ILIKE ?', "%#{params[:q]}%")
      #injection is possible!
    end
  end
end
