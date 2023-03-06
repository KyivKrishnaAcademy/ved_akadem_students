module LinkTos
  def link_to_show_academic_group_or_title(academic_group)
    link_to_if policy(academic_group).show?, academic_group.title, academic_group do
      academic_group.title
    end
  end

  def link_to_show_person_or_name(person, short: false)
    name = complex_name(person, short: short)

    link_to_if policy(person).show?, name, person_path(person) do
      name
    end
  end

  def link_to_new(condition, path)
    link_to_action(condition, path, 'success', t('links.new'), 'file')
  end

  def link_to_edit(condition, path)
    link_to_action(condition, path, 'warning', t('links.edit'), 'pencil')
  end

  def link_to_index(condition, path)
    link_to_action(condition, path, 'primary', t('links.list'), 'list')
  end

  def link_to_back(condition, path)
    link_to_action(condition, path, 'primary', t('links.back'), 'arrow-left')
  end

  def link_to_show(condition, path)
    link_to_action(condition, path, 'primary', t('links.show'), 'eye-open')
  end

  def link_to_destroy(condition, path)
    link_to_action(
      condition, path, 'danger', t('links.delete'), 'trash',
      data: { confirm: t('alerts.delete_confirmation') }, method: :delete
    )
  end

  def link_to_disabled_destroy(visibility_condition, disability_condition, path, disability_tooltip)
    return unless visibility_condition
    return link_to_destroy(true, path) unless disability_condition

    content_tag(
      :span,
      class: 'popover-enable disabled-button-with-popover',
      data: { toggle: :popover, content: disability_tooltip }
    ) do
      link_to_action(true, '', 'danger', '', 'trash', class: 'btn btn-xs btn-danger disabled', disabled: true)
    end
  end

  def link_to_action(condition, path, btn_color, tooltip, icon, params = {})
    return unless condition

    link_params = {
      class: "btn btn-xs btn-#{btn_color}",
      data: { toggle: :tooltip },
      title: tooltip
    }

    link_params.deep_merge!(params)

    link_to path, link_params do
      tag :span, class: "glyphicon glyphicon-#{icon}", aria: { hidden: true }
    end
  end
end
