module AcademicGroupsHelper
  def am_i_group_elder?(academic_group)
    [academic_group.curator_id,
     academic_group.administrator_id,
     academic_group.praepostor_id].include?(current_person.id)
  end

  def show_pdf_export_menu?
    current_person.can_act?('academic_group:group_list_pdf') ||
      current_person.can_act?('academic_group:attendance_template_pdf')
  end
end
