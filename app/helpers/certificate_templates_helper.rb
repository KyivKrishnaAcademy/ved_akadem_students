module CertificateTemplatesHelper
  def dimension_fields(cert_template)
    cert_template.fields.each do |field_key, field_content|
      if field_content.is_a?(Array)
        field_content.each_with_index do |dimensions, index|
          yield field_key, "#{field_key}_#{index}", dimensions, true
        end
      else
        yield field_key, field_key, field_content, false
      end
    end
  end

  def link_to_markup(condition, path)
    link_to_action(condition, path, 'warning', t('links.markup'), 'picture')
  end
end
