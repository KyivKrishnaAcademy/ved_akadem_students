class Users::EmailsController < ApplicationController
  def create
    @emails = HiddenEmail.collect_hidden_emails(params[:phone])
  end
end
