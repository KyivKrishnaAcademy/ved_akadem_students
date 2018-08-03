class CertificateTemplatesController < HtmlRespondableController
  before_action :set_certificate_template, only: %i[edit update destroy]

  after_action :verify_authorized

  def index
    @certificate_templates = CertificateTemplate.all

    authorize CertificateTemplate

    respond_with(@certificate_templates)
  end

  def new
    @certificate_template = CertificateTemplate.new

    authorize @certificate_template

    respond_with(@certificate_template)
  end

  def edit; end

  def create
    @certificate_template = CertificateTemplate.new(certificate_template_params)

    authorize @certificate_template

    @certificate_template.save

    respond_with(
      @certificate_template,
      location: -> { certificate_templates_path }
    )
  end

  def update
    @certificate_template.update(certificate_template_params)

    respond_with(
      @certificate_template,
      location: -> { edit_certificate_template_path(@certificate_template) }
    )
  end

  def destroy
    @certificate_template.destroy
    respond_with(@certificate_template)
  end

  private

  def set_certificate_template
    @certificate_template = CertificateTemplate.find(params[:id])

    authorize @certificate_template
  end

  def certificate_template_params
    params.require(:certificate_template).permit(:title, :background, :background_cache)
  end
end
