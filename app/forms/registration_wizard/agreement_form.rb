module RegistrationWizard
  class AgreementForm < RegistrationWizard::BaseForm
    ATTRIBUTE_NAMES = %i[
      privacy_agreement
    ]

    attr_accessor(*ATTRIBUTE_NAMES)

    validates :privacy_agreement, acceptance: { accept: 'yes' }

    def initialize(person:)
      @person = person
    end

    def assign_attributes(attrs)
      super(attrs.slice(*ATTRIBUTE_NAMES))
    end

    def save
      return false unless valid?

      update_completed_registration_step
    end
  end
end
