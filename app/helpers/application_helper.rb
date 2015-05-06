module ApplicationHelper
  def complex_name(person, short = false)
    if person.nil?
      'No such person'
    else
      if short
        person.spiritual_name.present? ? "#{person.spiritual_name}" : "#{person.surname} #{person.name}"
      else
        person.complex_name
      end
    end
  end

  def full_title(page_title)
    if page_title.empty?
      t(:application_title)
    else
      "#{t(:application_title)} | #{page_title}"
    end
  end

  def models_for_generic_menu
    %w(academic_group person course).map { |model| [model, model.pluralize] }
  end

  def show_admin_menu?
    current_person.present? && (show_people_menu? || show_academic_groups_menu? || show_courses_menu?)
  end

  def show_people_menu?
    current_person.can_act?(%w(person:index person:new))
  end

  def show_academic_groups_menu?
    current_person.can_act?(%w(academic_group:index academic_group:new))
  end

  def show_courses_menu?
    current_person.can_act?(%w(course:index course:new))
  end

  def person_photo(person, version = :default, options = {})
    if person.photo.present?
      image_tag "/people/show_photo/#{version}/#{person.id}", options
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

  def link_to_show_person_or_name(person, short = false)
    link_to_if policy(person).show?, complex_name(person, short), person_path(person) do
      complex_name(person, short)
    end
  end
end
