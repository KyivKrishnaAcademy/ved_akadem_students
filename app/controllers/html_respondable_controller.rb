require 'application_responder'

class HtmlRespondableController < ApplicationController
  self.responder = ApplicationResponder

  respond_to :html
end
