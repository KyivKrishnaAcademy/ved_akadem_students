class StaticPagesController < ApplicationController
  include StudyApplicationable

  skip_before_action :authenticate_person!

  before_action :preset_applications_variables, only: :home

  def home
    redirect_to new_person_session_path if current_person.blank?
  end
end
