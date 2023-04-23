module RegistrationWizard
  class IdentificationForm < RegistrationWizard::BaseForm
    ATTRIBUTE_NAMES = %i[
      spiritual_name
      diksha_guru
      name
      middle_name
      surname
      gender
    ]

    attr_accessor(*ATTRIBUTE_NAMES)

    before_validation :strip_whitespaces

    validates :gender, inclusion: { in: %w[male female] }
    validates :spiritual_name, :diksha_guru, :name, :middle_name, :surname, length: { maximum: 50 }
    validates :name, :surname, presence: true
    validates :diksha_guru, presence: true, if: :spiritual_name_present?

    def initialize(person:)
      @person = person
    end

    def assign_attributes(attrs)
      super(attrs.slice(*ATTRIBUTE_NAMES))
    end

    def save
      @gender = gender.blank? ? nil : gender

      return false unless valid?

      person.assign_attributes(
        spiritual_name: spiritual_name,
        diksha_guru: diksha_guru,
        name: name,
        middle_name: middle_name,
        surname: surname,
        gender: gender == 'male'
      )

      unless person.save
        add_model_errors(person)

        return false
      end

      update_completed_registration_step
    end

    private

    def spiritual_name_present?
      spiritual_name.present?
    end

    def strip_whitespaces
      spiritual_name.strip!
      diksha_guru.strip!
      name.strip!
      middle_name.strip!
      surname.strip!
      gender.strip! if gender.is_a?(String)
    end
  end
end
