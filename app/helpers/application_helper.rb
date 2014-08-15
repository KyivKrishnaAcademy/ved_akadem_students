module ApplicationHelper
  def full_title(page_title)
    if page_title.empty?
      t(:application_title)
    else
      "#{t(:application_title)} | #{page_title}"
    end
  end
end
