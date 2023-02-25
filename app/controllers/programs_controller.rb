class ProgramsController < HtmlRespondableController
  include Crudable

  after_action :verify_policy_scoped, only: %i[index edit update]

  def index
    @programs = policy_scope(Program).order(visible: :desc, position: :asc).includes(:manager)

    authorize Program

    respond_with(@programs)
  end

  def new
    @program = Program.new

    authorize @program

    respond_with(@program)
  end

  def edit
    respond_with(@program)
  end

  def create
    @program = Program.new(program_params)

    authorize @program

    @program.save

    respond_with(@program, location: programs_path)
  end

  def update
    @program.update(program_params)

    respond_with(@program, location: programs_path)
  end

  private

  def set_resource
    @program = policy_scope(Program).find(params[:id])

    authorize @program
  end

  def program_params
    permitted = params
                  .require(:program)
                  .permit(
                    :title_uk,
                    :title_ru,
                    :description_uk,
                    :description_ru,
                    :visible,
                    :position,
                    :manager_id
                  )

    permitted[:title_uk].strip!
    permitted[:title_ru].strip!
    permitted[:description_uk].strip!
    permitted[:description_ru].strip!

    permitted
  end
end
