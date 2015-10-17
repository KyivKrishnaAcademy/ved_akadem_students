class Api::PeopleLoadingInteraction < BaseInteraction
  def init
    @people_ids = params[:people_ids].map(&:to_i) if params[:people_ids].present?
    @people = if params[:people_ids].present?
      queried_payload.select { |p| @people_ids.include?(p[:id]) }
    else
      base_payload
    end

    @people.map! { |p| OpenStruct.new(p) }
  end

  def as_json(opts = {})
    {
      people: @people.map { |p| Api::PersonSerializer.as_json(p) },
      deleted: (@people_ids || []) - @people.map(&:id) #ids
    }
  end

  private

  def base_payload
    [
      {
        id: 1,
        spiritual_name: 'Adidas das',
        name: 'Андрій',
        middle_name: nil,
        surname: 'Пума',
        email: nil,
        birthday: Date.parse('1975/10/11'),
        groups: ['Викладачі', 'Адміністратори'],
        telephones: ['+380 50 111 22 33']
      },
      {
        id: 2,
        spiritual_name: nil,
        name: 'Василий',
        middle_name: 'Васильевич',
        surname: 'Васин',
        email: 'test1@example.com',
        birthday: Date.parse('1985/10/11'),
        groups: ['Студенти', 'ШБ15-1', 'УЧ15-2'],
        telephones: ['+380 50 111 22 34', '+380 50 111 22 35']
      },
      {
        id: 3,
        spiritual_name: 'Mahasarvajagadguru das',
        name: 'Михайло',
        middle_name: 'Михайлович',
        surname: 'Михайлов',
        email: 'test2@example.com',
        birthday: Date.parse('1965/10/11'),
        groups: ['Студенти', 'ШБ15-1', 'Старости'],
        telephones: ['+380 50 111 22 36']
      }
    ]
  end

  def queried_payload
    [
      {
        id: 1,
        spiritual_name: 'Adidas das',
        name: 'Андрій',
        middle_name: nil,
        surname: 'Пума',
        email: nil,
        birthday: Date.parse('1975/10/11'),
        groups: ['Викладачі', 'Адміністратори'],
        telephones: ['+380 50 111 22 33']
      },
      {
        id: 2,
        spiritual_name: nil,
        name: 'Василий',
        middle_name: 'Васильевич',
        surname: 'Васин',
        email: 'test1@example.com',
        birthday: Date.parse('1985/10/11'),
        groups: ['Студенти', 'ШБ15-1', 'УЧ15-2', 'Старости'],
        telephones: ['+380 50 111 22 34', '+380 50 111 22 35']
      }
    ]
  end
end
