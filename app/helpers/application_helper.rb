module ApplicationHelper
  def full_title(page_title)
    base_title = 'Kyiv Vedic Akademy Students'
    if page_title.empty?
      base_title
    else
      "#{base_title} | #{page_title}"
    end
  end

  def locale_label
    t("locale_label.#{session[:locale].present? ? session[:locale] : :uk}")
  end
end
