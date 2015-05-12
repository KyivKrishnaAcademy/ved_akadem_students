module AcademicGroupsHelper
  def am_i_group_elder?(academic_group)
    [academic_group.curator_id,
     academic_group.administrator_id,
     academic_group.praepostor_id].include?(current_person.id)
  end
end
