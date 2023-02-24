module ApplicationHelper
  include AutoGeneratedMenu
  include CurrentPage
  include LinkTos

  def complex_name(person, short: false)
    if person.nil?
      'No such person'
    elsif short
      person.diploma_name.presence || "#{person.surname} #{person.name}"
    else
      person.complex_name
    end
  end

  def full_title(page_title)
    if page_title.empty?
      t(:application_title)
    else
      "#{page_title} | #{t(:application_title)}"
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
    person_photo(
      person,
      :thumb,
      class: :'popover-photo',
      data: {
        toggle: :popover,
        content: person_photo(person, :standart).to_s
      }
    )
  end

  def inline_info(text)
    return unless text

    tag(
      :i,
      class: %w[fa fa-info-circle popover-info text-info inline-info],
      aria: { hidden: 'true' },
      data: { toggle: :popover, content: text }
    )
  end

  def link_to_person_with_photo(person)
    return unless person

    content_tag(:div, class: 'link-to-person-with-photo') do
      concat(thumb_with_pop(person))
      concat(link_to_show_person_or_name(person, short: true))
    end
  end

  def class_schedules_table_headers
    %w[course teacher subject groups classroom time actions].map do |key|
      I18n.t("class_schedules.table_headers.#{key}")
    end
  end

  def sidebar_opened?
    cookies[:'sidebar-is-opened']
  end
end
