module PaperTrailCustomSerializer
  # See https://github.com/paper-trail-gem/paper_trail/blob/v5.2.2/lib/paper_trail/serializers/yaml.rb

  module_function

  def load(string)
    ::PaperTrail::Serializers::YAML.load(string)
  end

  def dump(object)
    ::RemoveUploadersFromModelYamlDumpService.call(::PaperTrail::Serializers::YAML.dump(object))
  end

  def where_object_condition(arel_field, field, value)
    ::PaperTrail::Serializers::YAML.where_object_condition(arel_field, field, value)
  end

  def where_object_changes_condition(arel_field, field, value)
    ::PaperTrail::Serializers::YAML.where_object_changes_condition(arel_field, field, value)
  end
end
