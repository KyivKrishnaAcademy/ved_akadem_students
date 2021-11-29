module Api
  class PeopleLoadingInteraction < BaseInteraction
    def init
      @people_ids = params[:people_ids].map(&:to_i) if params[:people_ids].present?
      @people = if params[:people_ids].present?
        queried_payload.select { |p| @people_ids.include?(p[:id]) }
      else
        base_payload
      end

      @people.map! { |p| OpenStruct.new(p) }
    end

    def as_json(_opts = {})
      {
        people: @people.map { |p| Api::PersonSerializer.as_json(p) },
        deleted: (@people_ids || []) - @people.map(&:id) # TODO: ids
      }
    end

    private

    def base_payload
      [
        person1,
        person2,
        person3
      ]
    end

    def person1
      {
        id: 1,
        name: 'Андрій',
        middle_name: nil,
        surname: 'Пума',
        email: nil,
        birthday: Date.parse('1975/10/11'),
        groups: %w[Викладачі Адміністратори],
        telephones: ['+380 50 111 22 33']
      }
    end

    def person2
      {
        id: 2,
        name: 'Василий',
        middle_name: 'Васильевич',
        surname: 'Васин',
        email: 'test1@example.com',
        birthday: Date.parse('1985/10/11'),
        groups: %w[Студенти ШБ15-1 УЧ15-2],
        telephones: ['+380 50 111 22 34', '+380501112235']
      }
    end

    def person3
      {
        id: 3,
        name: 'Михайло',
        middle_name: 'Михайлович',
        surname: 'Михайлов',
        email: 'test2@example.com',
        birthday: Date.parse('1965/10/11'),
        groups: %w[Студенти ШБ15-1 Старости],
        telephones: ['+380 50 111 22 36']
      }
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
          groups: %W[\u0421\u0442\u0443\u0434\u0435\u043D\u0442\u0438 \u0428\u041115-1
                     \u0421\u0442\u0430\u0440\u043E\u0441\u0442\u0438],
          telephones: ['+380 50 111 22 34', '+380 50 111 22 38']
        }
      ]
    end
  end
end
