module Active
  module RegistrationWizard
    class SignUpStepInteraction < ActiveInteraction::Base
      string :email
      date :birthday
      string :password
      string :password_confirmation

      validates :email, format: /(\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z)/i, presence: true

      validates :password, confirmation: true
      validates :password, length: { in: 6..128 }
      validates :password, length: { in: 6..128 }, allow_blank: true

      validates :birthday, presence: true
      validate :validate_age

      def to_model
        Person.new
      end

      def execute
        person = Person.new(inputs)

        person.completed_registration_step = Person::RegistrationStep.next(person.completed_registration_step)

        errors.merge!(person.errors) unless person.save

        person
      end

      def validate_age
        return if birthday.blank? || birthday < 16.years.ago.to_date

        errors.add(:birthday, :over_16_years_old)
      end
    end
  end
end
