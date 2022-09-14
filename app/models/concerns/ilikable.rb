module Ilikable
  extend ActiveSupport::Concern

  class_methods do
    def ilike(field, query)
      where("#{field} ILIKE ?", "%#{sanitize_sql_like(query || '')}%")
    end
  end
end
