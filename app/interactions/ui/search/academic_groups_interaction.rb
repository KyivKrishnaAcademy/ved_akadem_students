module Ui
  module Search
    class AcademicGroupsInteraction < BaseInteraction
      include Rails.application.routes.url_helpers

      def init
        @groups = resource

        add_search_to_query

        @groups_page =
          @groups
            .page(page)
            .per(params[:length])

        @active_students_count =
          GroupParticipation
            .where(academic_group: @groups_page, leave_date: nil)
            .group(:academic_group_id)
            .count
      end

      def as_json(_opts = {})
        {
          draw: params[:draw].to_i,
          data: @groups_page.map { |r| serialize_resource r },
          recordsTotal: AcademicGroup.count,
          recordsFiltered: @groups.count
        }
      end

      private

      def page
        params[:start].to_i / params[:length].to_i + 1
      end

      def serialize_resource(group)
        {
          title: group.title,
          establ_date: group.establ_date,
          graduated_at: group.graduated_at,
          group_description: group.group_description,
          active_students_count: @active_students_count[group.id]
        }
      end

      def add_search_to_query
        search_query = params.dig('search', 'value')

        return if search_query.blank?

        @groups = @groups.ilike('title', search_query).or(@groups.ilike('group_description', search_query))
      end
    end
  end
end
