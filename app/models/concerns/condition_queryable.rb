module ConditionQueryable
  extend ActiveSupport::Concern

  CONDITION_MAPPER = {
    '=' => '=',
    '>' => '>',
    '>=' => '>=',
    '<' => '<',
    '<=' => '<=',
    '!=' => '!='
  }.freeze

  class_methods do
    def by_condition(field, condition, value)
      true_condition = CONDITION_MAPPER[condition] || '='

      where("#{field} #{true_condition} ?", sanitize_sql_for_conditions(value))
    end
  end
end
