class PersonDecorator < BaseDecorator
  def pending_docs
    @pending_docs ||= get_pending_docs
  end

  private

  def get_pending_docs
    result = {}

    result[:questionnaires] = resource.not_finished_questionnaires.count

    result.delete(:questionnaires) if result[:questionnaires].zero?

    [:photo, :passport].each do |person_field|
      if resource.send(person_field).blank?
        result[person_field] = person_field
      end
    end

    result
  end
end
