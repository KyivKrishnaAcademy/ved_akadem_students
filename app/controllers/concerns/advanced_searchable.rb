module AdvancedSearchable
  private

  def advanced_search(filters, general_search_fields, fields_mapper)
    filters.each do |filter|
      value = filter['value']
      field = filter['field']
      condition = filter['condition']

      case filter['type']
      when 'general-search'
        mix_general_search_query(general_search_fields, value)
      when 'text'
        mix_text_query(field, value, fields_mapper)
      when 'date'
        mix_condition_query(field, Date.parse(value), fields_mapper, condition)
      when 'datetime-local'
        mix_condition_query(field, Time.zone.parse(value), fields_mapper, condition)
      when 'number'
        mix_condition_query(field, value.to_i, fields_mapper, condition)
      end
    end
  end

  def mix_general_search_query(fields, value)
    @resource = @resource.ilike(fields, value)
  end

  def mix_text_query(field, value, fields_mapper)
    true_field = fields_mapper[field]

    return unless true_field

    @resource = @resource.ilike(true_field, value)
  end

  def mix_condition_query(field, value, fields_mapper, condition)
    true_field = fields_mapper[field]

    return unless true_field

    @resource = @resource.by_condition(true_field, condition, value)
  end
end
