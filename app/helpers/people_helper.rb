module PeopleHelper
  def complex_name(person, *title)
    if person.nil?
      'No such person'
    else
      if title.empty?
        person.complex_name
      else
        if person.spiritual_name.present?
          "#{person.spiritual_name}"
        else
          "#{person.surname} #{person.name}"
        end
      end
    end
  end
end
