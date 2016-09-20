module Peoplable
  def serialize_person(person)
    {
      id: person.id,
      text: person.complex_name,
      imageUrl: photo_url(person)
    }
  end

  def as_json(_opts = {})
    {
      people: @people.map { |p| serialize_person p }
    }
  end
end
