module RegistrationWizard
  class BaseForm < ::BaseForm
    attr_reader :person

    private

    def update_completed_registration_step
      person.update_attribute(
        :completed_registration_step,
        Person::RegistrationStep.next(person.completed_registration_step)
      )
    end
  end
end
