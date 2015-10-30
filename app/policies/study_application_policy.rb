class StudyApplicationPolicy < BasePolicy
  def create?
    owned? || super
  end

  def destroy?
    owned? || super
  end

  private

  def owned?
    record.person_id == user.id
  end
end
