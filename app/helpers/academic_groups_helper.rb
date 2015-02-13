module AcademicGroupsHelper
  def people_autocomplete(f, field)
    content_tag :div, class: ['form-group', field] do
      div_content = ''

      div_content << f.label(field)
      div_content << people_autocomplete_field(f, field)
      div_content << f.hidden_field("#{field}_id")

      div_content.html_safe
    end
  end

  def am_i_group_elder?(academic_group)
    [academic_group.curator_id,
     academic_group.administrator_id,
     academic_group.praepostor_id].include?(current_person.id)
  end

  private

  def people_autocomplete_field(form, field)
    form.autocomplete_field(field,
                            autocomplete_person_academic_groups_path,
                            id_element: "#academic_group_#{field}_id",
                            class: 'form-control',
                            value: form.object.send(field).present? ? form.object.send(field).complex_name : '')
  end
end
