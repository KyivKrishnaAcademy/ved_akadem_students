module Ui
  class AcademicGroupsLoadingInteraction < BaseInteraction
    include IdAndTitleLoadable

    def init
      # TODO: replace this when ElasticSearch appears
      @json_root = :academic_groups
      @resource = AcademicGroup
                    .where(graduated_at: nil)
                    .where('title ILIKE ?', "%#{params[:q]}%")
      # TODO: injection is possible!
    end
  end
end
