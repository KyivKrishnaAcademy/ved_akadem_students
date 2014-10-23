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
end
