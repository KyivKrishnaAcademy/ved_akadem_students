module RegistrationWizard
  class SignUpForm < BaseForm
    ATTRIBUTE_NAMES = %i[
      email
      birthday
      password
      password_confirmation
    ]

    attr_accessor(*ATTRIBUTE_NAMES)

    attr_reader :person, :is_persisted

    validates :email, format: /(\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z)/i, presence: true
    validates :password, length: { in: 6..128 }, confirmation: true
    validates :birthday, presence: true
    validate :validate_age

    def initialize
      @is_persisted = false
    end

    def assign_attributes(attrs)
      super(attrs.slice(*ATTRIBUTE_NAMES))
    end

    def save
      return false unless valid?

      @person = Person.new(
        email: email,
        birthday: birthday,
        password: password,
        password_confirmation: password_confirmation,
        completed_registration_step: Person::RegistrationStep.next('')
      )

      @is_persisted = person.save

      add_model_errors(person)
      is_persisted
    end

    private

    def validate_age
      return if birthday.blank? || birthday.to_date < 16.years.ago.to_date

      errors.add(:birthday, :over_16_years_old)
    end
  end
end
