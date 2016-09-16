module ApplicationHelper
  MODELS_FOR_GENERIC_MENU = %w(
    academic_group
    person
    course
    class_schedule
    certificate_template
  ).map { |model| [model, model.pluralize] }

  def complex_name(person, short = false)
    if person.nil?
      'No such person'
    elsif short
      person.spiritual_name.present? ? person.spiritual_name : "#{person.surname} #{person.name}"
    else
      person.complex_name
    end
  end

  def full_title(page_title)
    if page_title.empty?
      t(:application_title)
    else
      "#{t(:application_title)} | #{page_title}"
    end
  end

  def show_admin_menu?
    current_person.present? && (show_people_menu? || show_academic_groups_menu? ||
                                show_courses_menu? || show_class_schedules_menu? ||
                                show_certificate_templates_menu?)
  end

  def show_people_menu?
    current_person.can_act?(%w(person:index person:new))
  end

  def show_academic_groups_menu?
    current_person.can_act?(%w(academic_group:index academic_group:new))
  end

  def show_certificate_templates_menu?
    current_person.can_act?(%w(certificate_template:index certificate_template:new))
  end

  def show_courses_menu?
    current_person.can_act?(%w(course:index course:new))
  end

  def show_class_schedules_menu?
    current_person.can_act?(%w(class_schedule:index class_schedule:new))
  end

  def person_photo(person, version = :default, options = {})
    if person.photo.present?
      image_tag "/people/show_photo/#{version}/#{person.id}", options
    else
      image_tag person.photo.versions[version].url, options
    end
  end

  def thumb_with_pop(person)
    # rubocop:disable Style/UnneededInterpolation
    person_photo(
      person,
      :thumb,
      class: :'popover-photo',
      data: {
        toggle: :popover,
        content: "#{person_photo(person, :standart)}"
      }
    )
    # rubocop:enable Style/UnneededInterpolation
  end

  def link_to_show_person_or_name(person, short = false)
    link_to_if policy(person).show?, complex_name(person, short), person_path(person) do
      complex_name(person, short)
    end
  end

  def class_schedules_table_headers
    %w(course teacher subject groups classroom time actions).map do |key|
      I18n.t("class_schedules.table_headers.#{key}")
    end
  end

  def link_to_new(condition, path)
    link_to_action(condition, path, 'success', t('links.new'), 'file')
  end

  def link_to_edit(condition, path)
    link_to_action(condition, path, 'primary', t('links.edit'), 'pencil')
  end

  def link_to_index(condition, path)
    link_to_action(condition, path, 'primary', t('links.list'), 'list')
  end

  def link_to_destroy(condition, path)
    link_to_action(
      condition, path, 'danger', t('links.delete'), 'trash',
      data: { confirm: 'Are you sure?' }, method: :delete
    )
  end

  def link_to_action(condition, path, btn_color, tooltip, icon, params = {})
    if condition
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
end
