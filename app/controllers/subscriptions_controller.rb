class SubscriptionsController < HtmlRespondableController
  include Crudable

  def edit
    authorize @person, :subscriptions_edit?

    respond_with(@person)
  end

  def update
    authorize @person, :subscriptions_update?

    @person.update(person_params)

    respond_with(
      @person,
      location: root_path,
      notice: t('.notice'),
      alert: t('.alert_html', edit_path: edit_person_path(@person))
    )
  end

  private

  def set_resource
    @person = current_person
  end

  def person_params
    params.require(:person).permit(:notify_schedules)
  end
end
