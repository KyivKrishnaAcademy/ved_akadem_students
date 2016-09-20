module Api
  class PersonSerializer
    def self.as_json(p)
      result = {
        id: p.id,
        spiritual_name: p.spiritual_name,
        name: p.name,
        middle_name: p.middle_name,
        surname: p.surname,
        email: p.email,
        birthday: p.birthday,
        photo: 'https://pp.vk.me/c10513/u136975712/-14/x_5142fe55.jpg',
        groups: p.groups,
        telephones: p.telephones.map(&:phone)
      }

      result.merge(version: Digest::SHA1.hexdigest(result.to_s))
    end
  end
end
