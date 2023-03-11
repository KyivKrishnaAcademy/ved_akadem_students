module IdAndTitleLoadable
  def serialize_resource(resource)
    {
      id: resource.id,
      text: resource.title
    }
  end

  def as_json(_opts = {})
    page = @resource.page(params[:page]).per(20)

    {
      @json_root => page.map { |r| serialize_resource r },
      :more => !page.last_page?
    }
  end
end
