module PeopleHelper

  # Returns persons complex name for Person#show and show name for title
  def complex_name(person, *title)
    if person.nil?
      "No such person"
    else
      if !person.spiritual_name.blank?
        if title.empty?
          "#{person.spiritual_name} (#{person.name} #{person.middle_name} #{person.surname})"
        else
          "#{person.spiritual_name}"
        end
      else
        if title.empty?
          "#{person.name} #{person.middle_name} #{person.surname}"
        else
          "#{person.name} #{person.surname}"
        end
      end
    end
  end

end
