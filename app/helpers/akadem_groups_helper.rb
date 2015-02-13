module AkademGroupsHelper
  def people_autocomplete(f, field)
    content_tag :div, class: ['form-group', field] do
      div_content = ''

      div_content << f.label(field)
      div_content << people_autocomplete_field(f, field)
      div_content << f.hidden_field("#{field}_id")

      div_content.html_safe
    end
  end

  def am_i_group_elder?(akadem_group)
    [akadem_group.curator_id,
     akadem_group.administrator_id,
     akadem_group.praepostor_id].include?(current_person.id)
  end

  private

  def people_autocomplete_field(form, field)
    form.autocomplete_field(field,
                            autocomplete_person_akadem_groups_path,
                            id_element: "#akadem_group_#{field}_id",
                            class: 'form-control',
                            value: form.object.send(field).present? ? form.object.send(field).complex_name : '')
  end
end
