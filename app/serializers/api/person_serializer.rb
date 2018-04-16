module Api
  class PersonSerializer
    def self.as_json(person)
      result = {
        id: person.id,
        spiritual_name: person.spiritual_name,
        name: person.name,
        middle_name: person.middle_name,
        surname: person.surname,
        email: person.email,
        birthday: person.birthday,
        photo: 'https://pp.vk.me/c10513/u136975712/-14/x_5142fe55.jpg',
        groups: person.groups,
        telephones: person.telephones.map(&:phone)
      }

      result.merge(version: Digest::SHA1.hexdigest(result.to_s))
    end
  end
end
