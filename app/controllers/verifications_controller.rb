class VerificationsController < HtmlRespondableController
  after_action :verify_authorized

  def update
    authorize person, :verify?

    person.toggle!(:verified) # rubocop:disable Rails/SkipsModelValidations

    respond_with(person)
  end

  private

  def person
    @person ||= Person.find_by!(id: params[:person_id])
  end
end
