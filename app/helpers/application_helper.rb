module ApplicationHelper
  def full_title(page_title)
    if page_title.empty?
      t(:application_title)
    else
      "#{t(:application_title)} | #{page_title}"
    end
  end

  def show_admin_menu?
    current_person.present? && (show_admin_people_menu? || show_admin_group_menu?)
  end

  def show_admin_people_menu?
    current_person.can_act?(%w[person:index person:new])
  end

  def show_admin_group_menu?
    current_person.can_act?(%w[akadem_group:index akadem_group:new])
  end

  def person_photo(person, version = :default, options = {})
    if person.photo.present?
      image_tag "/people/show_photo/#{version.to_s}/#{person.id}", options
    else
      image_tag person.photo.versions[version].url, options
    end
  end

  def thumb_with_pop(person)
    person_photo(person,
                 :thumb,
                 class: 'popover-photo',
                 data: { toggle: 'popover',
                         content: "#{person_photo(person, :standart)}" })
  end

  def link_to_show_person_or_name(person)
    link_to_if policy(person).show?, person.complex_name, person_path(person) do
      person.complex_name
    end
  end
end
