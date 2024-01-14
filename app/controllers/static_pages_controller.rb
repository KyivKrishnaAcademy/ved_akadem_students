class StaticPagesController < ApplicationController
  include StudyApplicationable
  include CertificatesListable

  skip_before_action :authenticate_person!

  before_action :preset_applications_variables, only: :home

  def home
    redirect_to new_person_session_path if current_person.blank?

    @person_academic_groups = person_academic_groups

    preset_certificates(current_person&.student_profile)
  end

  private

  # rubocop:disable Metrics/CyclomaticComplexity
  # rubocop:disable Metrics/PerceivedComplexity
  def person_academic_groups
    [
      [current_person&.currently_praeposted_academic_groups, '.currently_praeposted_academic_groups'],
      [current_person&.previously_praeposted_academic_groups, '.previously_praeposted_academic_groups'],
      [current_person&.last_academic_groups, '.student_of_academic_groups'],
      [current_person&.previous_academic_groups, '.ex_student_of_academic_groups'],
      [current_person&.currently_curated_academic_groups, '.currently_curated_academic_groups'],
      [current_person&.previously_curated_academic_groups, '.previously_curated_academic_groups'],
      [current_person&.currently_administrated_academic_groups, '.currently_administrated_academic_groups'],
      [current_person&.previously_administrated_academic_groups, '.previously_administrated_academic_groups']
    ]
  end
  # rubocop:enable Metrics/CyclomaticComplexity
  # rubocop:enable Metrics/PerceivedComplexity
end
