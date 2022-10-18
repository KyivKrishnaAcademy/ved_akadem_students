module Ui
  class ClassroomsLoadingInteraction < BaseInteraction
    include IdAndTitleLoadable

    def init
      @json_root = :classrooms
      @resource  = Classroom.ilike('title', params[:q])
    end
  end
end
