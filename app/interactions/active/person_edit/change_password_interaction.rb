module Active
  module PersonEdit
    class ChangePasswordInteraction < ActiveInteraction::Base
      object :person

      string :current_password
      string :password
      string :password_confirmation

      validates :current_password, presence: true
      validates :password, confirmation: true
      validates :password, length: { in: 6..128 }

      def to_model
        person
      end

      def execute
        is_updated = person.update_with_password(
          current_password: current_password,
          password: password,
          password_confirmation: password_confirmation
        )

        errors.merge!(person.errors) unless is_updated

        person
      end
    end
  end
end
