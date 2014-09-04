class StaticPagesController < ApplicationController
  include StudyApplicationable

  before_action :authenticate_person!, only: :home
  before_action :set_programs_and_new_application, only: :home
end
