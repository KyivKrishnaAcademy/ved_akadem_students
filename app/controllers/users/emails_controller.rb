class Users::EmailsController < ApplicationController
  def update
    @emails = HiddenEmail.collect_hidden_emails(params[:phone])
  end
end
