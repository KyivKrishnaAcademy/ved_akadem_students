class AkademGroupPolicy < ApplicationPolicy
  def autocomplete_person?
    edit?
  end
end
