module RegistrationWizard
  class TelephonesForm < RegistrationWizard::BaseForm
    def initialize(person:)
      @person = person
    end

    def save
      false
    end
  end
end
