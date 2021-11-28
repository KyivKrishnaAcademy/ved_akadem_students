class VerificationsController < HtmlRespondableController
  after_action :verify_authorized

  def update
    authorize person, :verify?

    person.toggle!(:verified)

    respond_with(person)
  end

  private

  def person
    @person ||= Person.find(params[:person_id])
  end
end
