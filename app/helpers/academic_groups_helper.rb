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

  def attendance_localization
    %i[
      absend
      back
      forth
      present
      unknown
    ].index_with do |key|
      I18n.t("group_attendance.attendance_submitter.#{key}")
    end
  end

  def examination_reults_localization
    %i[
      min
      max
      save
      delete
      passing
    ].index_with do |key|
      I18n.t("group_performance.editor.#{key}")
    end
  end

  def date_value(date)
    date.present? ? l(date, format: :date_picker) : ''
  end
end
