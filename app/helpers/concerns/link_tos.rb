module LinkTos
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

  def link_to_destroy(condition, path)
    link_to_action(
      condition, path, 'danger', t('links.delete'), 'trash',
      data: { confirm: t('alerts.delete_confirmation') }, method: :delete
    )
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
