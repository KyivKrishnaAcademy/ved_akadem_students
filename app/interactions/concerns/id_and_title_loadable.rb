module IdAndTitleLoadable
  def serialize_resource(resource)
    { id: resource.id,
      text: resource.title }
  end

  def as_json(opts = {})
    { @json_root => @resource.map { |r| serialize_resource r } }
  end
end
