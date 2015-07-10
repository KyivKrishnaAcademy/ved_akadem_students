module PeopleHelper
  def not_adult_warning(birthday)
    content_tag(:span, t('people.show.not_adult'), class: :'text-danger') if birthday > 18.years.ago
  end
end
