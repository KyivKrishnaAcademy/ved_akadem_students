module Active
  module PeopleRegistration
    class AgreementStepInteraction < ActiveInteraction::Base
      object :person
      string :privacy_agreement

      validates :privacy_agreement, acceptance: { accept: 'yes' }

      def to_model
        person
      end

      def execute
        person.completed_registration_step = Person::RegistrationStep.next(person.completed_registration_step)

        errors.merge!(person.errors) unless person.save

        person
      end
    end
  end
end
