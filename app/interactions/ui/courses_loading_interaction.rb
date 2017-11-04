module Ui
  class CoursesLoadingInteraction < BaseInteraction
    include IdAndTitleLoadable

    def init
      # TODO: replace this when ElasticSearch appears
      @json_root = :courses
      @resource  = Course.where('title ILIKE ?', "%#{params[:q]}%")
      # TODO: injection is possible!
    end

    def serialize_resource(course)
      {
        id: course.id,
        text: course.label_for_select
      }
    end
  end
end
