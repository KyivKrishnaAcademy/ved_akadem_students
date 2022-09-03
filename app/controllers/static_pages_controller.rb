class StaticPagesController < ApplicationController
  include StudyApplicationable
  include CertificatesListable

  skip_before_action :authenticate_person!

  before_action :preset_applications_variables, only: :home

  def home
    redirect_to new_person_session_path if current_person.blank?

    preset_certificates(current_person.student_profile)
  end
end
