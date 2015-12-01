class CertificateTemplatesController < HtmlRespondableController
  before_action :set_certificate_template, only: %i(edit update destroy markup finish background)

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

  def edit
  end

  def create
    @certificate_template = CertificateTemplate.new(certificate_template_params)

    authorize @certificate_template

    @certificate_template.save

    respond_with(
      @certificate_template,
      location: -> { markup_certificate_template_path(@certificate_template) }
    )
  end

  def markup
    @certificate_template.init_fields
  end

  def finish
    if @certificate_template.update(finish_params)
      redirect_to @certificate_template
    else
      render :markup
    end
  end

  def background
    send_file(@certificate_template.background.preview.url,
              disposition: 'inline',
              type: @certificate_template.background.preview.content_type,
              x_sendfile: true)
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

  def finish_params
    fields = CertificateTemplate::FIELDS.map do |field|
      [field, CertificateTemplate::DIMENSIONS]
    end

    array_fields = CertificateTemplate::ARRAY_FIELDS.map do |field|
      [field, [CertificateTemplate::DIMENSIONS]]
    end

    params.require(:certificate_template).permit(fields: (fields + array_fields).to_h)
  end
end
