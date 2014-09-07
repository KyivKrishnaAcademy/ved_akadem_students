class BaseDecorator
  attr_reader :resource

  def initialize(resource)
    @resource = resource
  end

  def method_missing(method_name, *args, &block)
    resource.send(method_name, *args, &block)
  end

  def respond_to_missing?(method_name, include_private = false)
    resource.respond_to?(method_name, include_private) || super
  end
end
