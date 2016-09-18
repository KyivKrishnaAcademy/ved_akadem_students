module Ui
  class ClassroomsLoadingInteraction < BaseInteraction
    include IdAndTitleLoadable

    def init
      # TODO: replace this when ElasticSearch appears
      @json_root = :classrooms
      @resource  = Classroom.where('title ILIKE ?', "%#{params[:q]}%")
      # TODO: injection is possible!
    end
  end
end
