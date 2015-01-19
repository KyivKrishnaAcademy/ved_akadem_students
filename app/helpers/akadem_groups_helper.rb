module AkademGroupsHelper
  def people_autocomplete(f, field)
    content_tag :div, class: ['form-group', field] do
      div_content = ''

      div_content << f.label(field)
      div_content << f.autocomplete_field(field,
                                          autocomplete_person_akadem_groups_path,
                                          id_element: "#akadem_group_#{field}_id",
                                          class: 'form-control',
                                          value: f.object.send(field).present? ? f.object.send(field).complex_name : '')
      div_content << f.hidden_field("#{field}_id")

      div_content.html_safe
    end
  end
end
