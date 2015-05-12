class BaseInteraction
  attr_accessor :user, :params, :request

  def initialize(args)
    @user    = args[:user]
    @params  = args[:params]
    @request = args[:request]

    init
    exec
  end

  def init
  end

  def exec
  end

  def as_json(opts = {})
    raise StandardError.new('Interaction.as_json should be overridden!')
  end

  private

  def photo_url(person)
    person.photo.present? ? "/people/show_photo/thumb/#{person.id}" : person.photo.thumb.url
  end
end
