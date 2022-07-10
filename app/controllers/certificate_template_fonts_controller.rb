class CertificateTemplateFontsController < HtmlRespondableController
  before_action :set_certificate_template_font, only: %i[edit update destroy]

  after_action :verify_authorized

  def index
    @certificate_template_fonts = CertificateTemplateFont.all

    authorize CertificateTemplateFont

    respond_with(@certificate_template_fonts)
  end

  def new
    @certificate_template_font = CertificateTemplateFont.new

    authorize @certificate_template_font

    respond_with(@certificate_template_font)
  end

  def edit; end

  def create
    @certificate_template_font = CertificateTemplateFont.new(certificate_template_font_params)

    authorize @certificate_template_font

    @certificate_template_font.save

    respond_with(
      @certificate_template_font,
      location: -> { certificate_template_fonts_path }
    )
  end

  def update
    @certificate_template_font.update(certificate_template_font_params)

    respond_with(
      @certificate_template_font,
      location: -> { edit_certificate_template_path(@certificate_template_font) }
    )
  end

  def destroy
    @certificate_template_font.destroy
    respond_with(@certificate_template_font)
  end

  private

  def set_certificate_template_font
    @certificate_template_font = CertificateTemplateFont.find(params[:id])

    authorize @certificate_template_font
  end

  def certificate_template_font_params
    params.require(:certificate_template_font).permit(:name, :file)
  end
end
