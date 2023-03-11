module Peoplable
  def serialize_person(person)
    {
      id: person.id,
      text: person.complex_name,
      imageUrl: photo_url(person)
    }
  end

  def as_json(_opts = {})
    page = @people.page(params[:page]).per(20)

    {
      people: page.map { |p| serialize_person p },
      more: !page.last_page?
    }
  end
end
