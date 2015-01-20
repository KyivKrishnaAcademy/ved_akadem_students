class AkademGroupPolicy < ApplicationPolicy
  def autocomplete_person?
    edit?
  end

  def show?
    super || student_of_the_group? || record.curator_id == user.id || record.administrator_id == user.id
  end

  private

    def student_of_the_group?
      user.student_profile.present? && record.active_student_profiles.include?(user.student_profile)
    end
end
