module RegistrationWizard
  class TelephonesForm < RegistrationWizard::BaseForm
    delegate :telephones, to: :person

    validates :telephones, presence: true

    def initialize(person:)
      @person = person
    end

    def assign_attributes(attrs)
      super(attrs.slice(:telephones_attributes))
    end

    def telephones_attributes=(att)
      @person.telephones_attributes = att
    end

    def self.reflect_on_association(*args)
      Person.reflect_on_association(*args)
    end

    def save
      return false unless valid?

      unless person.save
        add_model_errors(person)

        return false
      end

      update_completed_registration_step
    end
  end
end
