class PersonDecorator < BaseDecorator
  def pending_docs
    @pending_docs ||= count_pending_docs
  end

  private

  def count_pending_docs
    result = {}

    result[:questionnaires] = resource.not_finished_questionnaires.count

    result.delete(:questionnaires) if result[:questionnaires].zero?

    [:photo, :passport].each do |person_field|
      result[person_field] = person_field if resource.send(person_field).blank?
    end

    result
  end
end
