module Ui
  class GroupAdminsLoadingInteraction < BaseInteraction
    include Peoplable

    def init
      # TODO: replace this when ElasticSearch appears
      @people = Person.where('complex_name ILIKE ?', "%#{params[:q]}%")
      # TODO: injection is possible!
    end
  end
end
