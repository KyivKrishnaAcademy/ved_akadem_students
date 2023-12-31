module Person::RegistrationStep
  STEPS = %w[sign_up agreement identification telephones]
  COUNT = STEPS.length
  SUCCESSION = [''].concat(STEPS).zip(STEPS).to_h

  def self.next(previous_step)
    SUCCESSION[previous_step]
  end

  def self.last?(step)
    STEPS.last == step
  end

  def self.index(step)
    STEPS.index(step)
  end
end
