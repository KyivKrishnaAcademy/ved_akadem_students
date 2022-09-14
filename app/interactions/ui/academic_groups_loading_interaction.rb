module Ui
  class AcademicGroupsLoadingInteraction < BaseInteraction
    include IdAndTitleLoadable

    def init
      @json_root = :academic_groups
      @resource = AcademicGroup
                    .where(graduated_at: nil)
                    .ilike('title', params[:q])
    end
  end
end
