class Users::EmailsController < ApplicationController
  def update
    @emails = HiddenEmail.collect_hiden_emails(params[:phone])
  end
end
