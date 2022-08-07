module PersonSetable
  private

  def set_person
    @person = policy_scope(Person).find(params[:id] || params[:person_id])

    authorize @person
  end
end
