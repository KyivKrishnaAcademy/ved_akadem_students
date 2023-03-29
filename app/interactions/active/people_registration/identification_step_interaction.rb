module Active
  module PeopleRegistration
    class IdentificationStepInteraction < ActiveInteraction::Base
      object :person

      string :spiritual_name
      string :diksha_guru
      string :name
      string :middle_name
      string :surname
      string :gender

      validates :gender, inclusion: { in: %w[male female] }
      validates :spiritual_name, :diksha_guru, :name, :middle_name, :surname, length: { maximum: 50 }
      validates :name, :surname, presence: true
      validates :diksha_guru, presence: true, if: :spiritual_name_present?

      def to_model
        person
      end

      def execute
        person.assign_attributes(
          spiritual_name: spiritual_name.strip,
          diksha_guru: diksha_guru.strip,
          name: name.strip,
          middle_name: middle_name.strip,
          surname: surname.strip,
          gender: gender == 'male'
        )

        person.completed_registration_step = Person::RegistrationStep.next(person.completed_registration_step)

        errors.merge!(person.errors) unless person.save

        person
      end

      private

      def spiritual_name_present?
        spiritual_name.present?
      end
    end
  end
end
