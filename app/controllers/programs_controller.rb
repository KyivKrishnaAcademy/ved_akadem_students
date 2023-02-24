class ProgramsController < HtmlRespondableController
  include Crudable

  after_action :verify_policy_scoped, only: %i[index]

  def index
    @programs = policy_scope(Program).order(visible: :desc, position: :asc).includes(:manager)

    authorize Program

    respond_with(@programs)
  end
end
