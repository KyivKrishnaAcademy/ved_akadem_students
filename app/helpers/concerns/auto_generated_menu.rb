module AutoGeneratedMenu
  include AbilityShortcuts

  SIDEBAR_MENU = [
    %i(course courses fa-book),
    %i(class_schedule class_schedules fa-calendar),
    %i(certificate_template certificate_templates fa-certificate)
  ].freeze

  def active_class(*pathes)
    pathes.any? { |path| current_path?(path, enforce_params: true) } ? 'is-active' : ''
  end

  def generated_sidebar_menu
    safe_join(SIDEBAR_MENU.map { |name, plural_name, icon| generate_menu_group(name, plural_name, icon) })
  end

  def generate_menu_group(name, plural_name, icon, options = {}, &block)
    return unless send("show_#{plural_name}_menu?")

    new_path = send("new_#{name}_path")
    list_path = send("#{plural_name}_path")

    html = check_box_tag name, :checked, cookies["#{name}-submenu-is-opened"].present?, class: 'group-status'

    html << generate_label(name, plural_name, icon)
    html << content_tag(:ul, generate_items(name, plural_name, new_path, list_path, block, options))

    content_tag :li, html
  end

  def generate_label(name, plural_name, icon)
    label_tag name do
      content = content_tag :i, nil, class: "sidebar-icon fa fa-2x #{icon}", aria: { hidden: :true }

      content << t("defaults.links.#{plural_name}")
      content << content_tag(:span, nil, class: :caret)

      content
    end
  end

  def generate_items(name, plural_name, new_path, list_path, block, options)
    new_li = if !options[:skip_new] && current_person.can_act?("#{name}:new")
      content_tag :li do
        link_to t("defaults.links.#{plural_name}_add"), new_path, class: active_class(new_path)
      end
    end

    list_li = if !options[:skip_list] && current_person.can_act?("#{name}:index")
      content_tag :li do
        link_to t("defaults.links.#{plural_name}_list"), list_path, class: active_class(list_path)
      end
    end

    safe_join([new_li, list_li, block&.call])
  end
end
