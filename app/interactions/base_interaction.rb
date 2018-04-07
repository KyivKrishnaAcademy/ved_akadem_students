class BaseInteraction
  attr_accessor :user, :params, :resource

  def initialize(args)
    @user     = args[:user]
    @params   = args[:params]
    @resource = args[:resource]

    init
  end

  def init; end

  def as_json(_opts = {})
    {}
  end

  def status
    @status || :ok
  end

  private

  def errors_json(resource)
    { errors: resource.errors.full_messages }
  end

  def photo_url(person)
    person.photo.present? ? "/people/show_photo/thumb/#{person.id}" : person.photo.thumb.url
  end
end
