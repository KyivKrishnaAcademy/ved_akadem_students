module Ui
  class CoursesLoadingInteraction < BaseInteraction
    include IdAndTitleLoadable

    def init
      @json_root = :courses
      @resource  = Course.ilike('title', params[:q])
    end

    def serialize_resource(course)
      {
        id: course.id,
        text: course.label_for_select
      }
    end
  end
end
