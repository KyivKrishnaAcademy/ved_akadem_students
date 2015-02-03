module PeopleHelper
  def complex_name(person, title = false)
    if person.nil?
      'No such person'
    else
      if title
        if person.spiritual_name.present?
          "#{person.spiritual_name}"
        else
          "#{person.surname} #{person.name}"
        end
      else
        person.complex_name
      end
    end
  end
end
