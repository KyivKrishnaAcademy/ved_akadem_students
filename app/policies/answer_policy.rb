class AnswerPolicy < BasePolicy
  def show?
    super || record.person_id == user.id
  end
end
