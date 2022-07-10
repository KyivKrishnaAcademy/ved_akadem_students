class CertificatePolicy < BasePolicy
  def show?
    super || record.student_profile.person_id == user.id
  end
end
