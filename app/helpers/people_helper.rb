module PeopleHelper
  def complex_name(person, *title)
    if person.nil?
      'No such person'
    else
      if !person.spiritual_name.blank?
        if title.empty?
          "#{person.spiritual_name} (#{person.surname} #{person.name} #{person.middle_name})"
        else
          "#{person.spiritual_name}"
        end
      else
        if title.empty?
          "#{person.surname} #{person.name} #{person.middle_name}"
        else
          "#{person.surname} #{person.name}"
        end
      end
    end
  end
end
