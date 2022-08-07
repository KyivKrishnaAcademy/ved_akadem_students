module PaperTrail
  class VersionPolicy < BasePolicy
    def show?
      if record.is_a?(PaperTrail::Version)
        object = record.reify || record.item || record.next&.reify
        policy = Pundit.policy(user, object)

        if policy
          policy.show?
        else
          ::Rails.logger.warn("Couldn't find policy VersionPolicy for #{object.class}")

          super
        end
      else
        super
      end
    end
  end
end
