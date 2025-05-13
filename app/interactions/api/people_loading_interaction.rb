module Api
  class PeopleLoadingInteraction < BaseInteraction
    PersonStruct = Struct.new(
      :id, :name, :middle_name, :surname, :email, :birthday, :groups, :telephones,
      keyword_init: true
    )

    def initialize(params)
      super
      @people_ids = params[:people_ids]&.map(&:to_i)
      @people = filter_people
    end

    def as_json(_opts = {})
      {
        people: @people.map { |p| Api::PersonSerializer.as_json(p) },
        deleted: (@people_ids || []) - @people.map(&:id)
      }
    end

    private

    def filter_people
      people_data = params[:people_ids].present? ? queried_payload : base_payload
      people_data.select! { |p| @people_ids.include?(p[:id]) } if @people_ids
      people_data.map { |p| PersonStruct.new(p) }
    end

    def base_payload
      [person1, person2, person3]
    end

    def person1
      { id: 1, name: 'Андрій', middle_name: nil, surname: 'Пума', email: nil, birthday: Date.parse('1975/10/11'),
        groups: %w[Викладачі Адміністратори], telephones: ['+380 50 111 22 33'] }
    end

    def person2
      {
        id: 2,
        name: 'Василий',
        middle_name: 'Васильевич',
        surname: 'Васин',
        email: 'test1@example.com',
        birthday: Date.parse('1985/10/11'),
        groups: %w[
          Студенти
          ШБ15-1
          УЧ15-2
        ],
        telephones: [
          '+380 50 111 22 34',
          '+380501112235'
        ]
      }
    end

    def person3
      { id: 3, name: 'Михайло', middle_name: 'Михайлович', surname: 'Михайлов', email: 'test2@example.com',
        birthday: Date.parse('1965/10/11'), groups: %w[Студенти ШБ15-1 Старости], telephones: ['+380 50 111 22 36'] }
    end

    def queried_payload
      [
        {
          id: 1,
          name: 'Андрій',
          middle_name: nil,
          surname: 'Пума',
          email: nil,
          birthday: Date.parse('1975/10/11'),
          groups: %w[Викладачі Адміністратори],
          telephones: ['+380 50 111 22 33']
        },
        {
          id: 2,
          name: 'Вася',
          middle_name: nil,
          surname: 'Васютин',
          email: 'test12@example.com',
          birthday: Date.parse('1985/10/12'),
          groups: %w[Студенти ШБ15-1 Старости],
          telephones: ['+380 50 111 22 34', '+380 50 111 22 38']
        }
      ]
    end
  end
end
