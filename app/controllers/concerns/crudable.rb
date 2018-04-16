module Crudable
  extend ActiveSupport::Concern

  included do
    before_action :set_resource, only: %i[show edit update destroy] # rubocop:disable Rails/LexicallyScopedActionFilter

    after_action :verify_authorized
  end

  private

  def set_resource
    raise 'Redefine me!'
  end
end
