class Unsubscribe < ApplicationRecord
  belongs_to :person

  class << self
    def generate(person, kind)
      code = loop do
        code = SecureRandom.urlsafe_base64

        break code if where(code: code, email: person.email).none?
      end

      create!(code: code, person: person, email: person.email, kind: kind)
    end
  end

  def encoded_email
    Base64.urlsafe_encode64(email, padding: false)
  end
end
