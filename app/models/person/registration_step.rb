module Person::RegistrationStep
  STEPS = %w[sign_up agreement identification telephones]

  def self.last?(step)
    STEPS.last == step
  end
end
