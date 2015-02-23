require 'application_responder'

class HtmlResponsableController < ApplicationController
  self.responder = ApplicationResponder

  respond_to :html
end
