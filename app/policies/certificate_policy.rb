class CertificatePolicy < BasePolicy
  def show?
    super || record.student_profile.person_id == user.id
  end

  def index?
    super || user.can_act?('certificate_template:index')
  end

  def destroy?
    super || user.can_act?('certificate_template:destroy')
  end
end
