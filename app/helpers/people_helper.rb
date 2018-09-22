module PeopleHelper
  def not_adult_warning(birthday)
    content_tag(:span, t('people.show.not_adult'), class: :'text-danger') if birthday > 16.years.ago
  end

  def leave_reason(group_participation)
    academic_group = group_participation.academic_group

    if academic_group.graduated_at.present? && academic_group.graduated_at <= group_participation.leave_date
      'graduation'
    else
      'manual'
    end
  end
end
