module Ui
  class CoursesLoadingInteraction < BaseInteraction
    include IdAndTitleLoadable

    def init
      # TODO: replace this when ElasticSearch appears
      @json_root = :courses
      @resource  = Course.where('title ILIKE ?', "%#{params[:q]}%")
      # TODO: injection is possible!
    end
  end
end
