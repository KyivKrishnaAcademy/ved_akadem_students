class HiddenEmail
  def self.collect_hidden_emails(telephone)
    Person.joins(:telephones)
          .where(telephones: { phone: GlobalPhone.normalize(telephone) })
          .order(:id).pluck(:email)
          .map { |email| hide_email(email) }
  end

  def self.hide_email(email)
    split = email.split('@')
    size  = split.first.size

    (1...size).to_a.sample(size / 2).each do |index|
      split.first[index] = '*'
    end

    split.join('@')
  end
end
