class UnsubscribesController < ApplicationController
  skip_before_action :authenticate_person!

  before_action :set_unsubscribe, only: %i[edit destroy]

  def edit; end

  def destroy
    redirect_to root_path
  end

  private

  def decode_email(email)
    return nil if email.blank?

    Base64.urlsafe_decode64(email)
  rescue ArgumentError
    nil
  end

  def set_unsubscribe
    email = decode_email(params[:email])
    @unsubscribe = Unsubscribe.find_by(code: params[:code], email: email)
  end

  def unsubscribe_person!
    return false if @unsubscribe.blank? || @unsubscribe.person.blank?

    if @unsubscribe.person.update(@unsubscribe.kind => false)
      @unsubscribe.destroy
      true
    else
      false
    end
  end
end