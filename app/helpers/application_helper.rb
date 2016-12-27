module ApplicationHelper
  include AbilityShortcuts
  include LinkTos

  SIDEBAR_MENU = {
    person: { plural_name: :people, icon: :'fa-users' },
    course: { plural_name: :courses, icon: :'fa-book' },
    class_schedule: { plural_name: :class_schedules, icon: :'fa-calendar' },
    certificate_template: { plural_name: :certificate_templates, icon: :'fa-certificate' }
  }

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

  def class_schedules_table_headers
    %w(course teacher subject groups classroom time actions).map do |key|
      I18n.t("class_schedules.table_headers.#{key}")
    end
  end

  def active_class(*pathes)
    pathes.any? { |path| current_page?(path) } ? 'active' : ''
  end

  def sidebar_opened?
    cookies[:sidebar_opened]
  end
end
