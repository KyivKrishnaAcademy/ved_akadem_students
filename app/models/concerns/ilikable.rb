module Ilikable
  extend ActiveSupport::Concern

  class_methods do
    def ilike(*fields, query)
      query_fields = fields.flatten.map { |field| "#{field} ILIKE :query" }.join(' OR ')

      where(query_fields, query: "%#{sanitize_sql_like(query || '')}%")
    end
  end
end
