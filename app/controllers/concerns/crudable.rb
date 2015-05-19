module Crudable
  extend ActiveSupport::Concern

  included do
    before_action :set_resource, only: [:show, :edit, :update, :destroy]

    after_action :verify_authorized
  end

  private

  def set_resource
    raise 'Redefine me!'
  end
end
