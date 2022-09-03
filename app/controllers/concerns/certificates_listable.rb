module CertificatesListable
  private

  def preset_certificates(student_profile)
    @certificates = if student_profile.present?
      Certificate
        .where(student_profile_id: student_profile.id)
        .order(:serial_id)
        .preload(:certificate_template)
    else
      []
    end
  end
end
