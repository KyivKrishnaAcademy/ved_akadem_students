class UnsubscribesController < ApplicationController
  skip_before_action :authenticate_person!

  before_action :set_unsubscribe, only: %i[edit destroy]

  def edit; end

  def destroy
    unsubscribe_person!
  end

  private

  def set_unsubscribe
    email = Base64.urlsafe_decode64(params[:email]) rescue nil # rubocop:disable Style/RescueModifier
    @unsubscribe = Unsubscribe.find_by(code: params[:code], email: email)
  end

  def unsubscribe_person!
    return if @unsubscribe.blank?

    # rubocop:disable Rails/SkipsModelValidations
    @unsubscribe.destroy if @unsubscribe.person.update_column(@unsubscribe.kind, false)
    # rubocop:enable Rails/SkipsModelValidations
  end
end
