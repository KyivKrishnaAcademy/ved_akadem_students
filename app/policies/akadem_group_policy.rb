class AkademGroupPolicy < ApplicationPolicy
  def autocomplete_person?
    edit?
  end

  def show?
    super || student_of_the_group? || record.curator_id == user.id || record.administrator_id == user.id
  end

  private

    def student_of_the_group?
      record.active_students.map(&:id).include?(user.id)
    end
end
