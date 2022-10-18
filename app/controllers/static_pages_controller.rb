class StaticPagesController < ApplicationController
  include StudyApplicationable
  include CertificatesListable

  skip_before_action :authenticate_person!

  before_action :preset_applications_variables, only: :home

  def home
    redirect_to new_person_session_path if current_person.blank?

    @person_academic_groups = [
      [current_person&.last_academic_groups, '.student_of_academic_groups'],
      [current_person&.previous_academic_groups, '.ex_student_of_academic_groups'],
      [current_person&.current_curated_academic_groups, '.current_curated_academic_groups'],
      [current_person&.previous_curated_academic_groups, '.previous_curated_academic_groups']
    ]

    preset_certificates(current_person&.student_profile)
  end
end
