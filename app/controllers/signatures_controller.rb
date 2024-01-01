class SignaturesController < HtmlRespondableController
  before_action :set_signature, only: %i[edit update destroy]

  after_action :verify_authorized

  def index
    @signatures = Signature.all

    authorize Signature

    respond_with(@signatures)
  end

  def new
    @signature = Signature.new

    authorize @signature

    respond_with(@signature)
  end

  def edit; end

  def create
    @signature = Signature.new(signature_params)

    authorize @signature

    @signature.save

    respond_with(
      @signature,
      location: -> { signatures_path }
    )
  end

  def update
    @signature.update(signature_params)

    respond_with(
      @signature,
      location: -> { edit_signature_path(@signature) }
    )
  end

  def destroy
    @signature.destroy
    respond_with(@signature)
  end

  private

  def set_signature
    @signature = Signature.find(params[:id])

    authorize @signature
  end

  def signature_params
    params.require(:signature).permit(:name, :file)
  end
end
