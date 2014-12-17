class Users::EmailsController < ApplicationController
  skip_before_action :authenticate_person!

  def create
    if verify_recaptcha
      @emails = HiddenEmail.collect_hidden_emails(params[:phone])
    else
      render :new
    end
  end
end
