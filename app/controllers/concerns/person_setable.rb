module PersonSetable
  private

  def set_person
    @person = policy_scope(Person).find(params[:id])

    authorize @person
  end
end
