require 'rails_helper'

RSpec.describe CertificatesController, type: :controller do
  let(:person) { create(:person) }
  let(:certificate_template) { create(:certificate_template) }
  let!(:certificate) { create(:certificate, certificate_template: certificate_template) }

  before do
    sign_in person
    allow_any_instance_of(CertificatePolicy).to receive(:destroy?).and_return(true)
    allow_any_instance_of(CertificatePolicy).to receive(:index?).and_return(true)
  end

  describe 'GET #index' do
    it 'returns a successful response' do
      get :index, params: { certificate_template_id: certificate_template.id }
      expect(response).to have_http_status(:success)
    end

    it 'assigns @certificates' do
      get :index, params: { certificate_template_id: certificate_template.id }
      expect(assigns(:certificates)).to eq([certificate])
    end
  end

  describe 'DELETE #destroy' do
    context 'when certificate exists' do
      it 'authorizes the certificate' do
        expect_any_instance_of(CertificatePolicy).to receive(:destroy?)
        delete :destroy, params: { id: certificate.id, certificate_template_id: certificate_template.id }, headers: { "HTTP_REFERER" => certificate_templates_path }
      end

      it 'destroys the certificate' do
        expect {
          delete :destroy, params: { id: certificate.id, certificate_template_id: certificate_template.id }, headers: { "HTTP_REFERER" => certificate_templates_path }
        }.to change(Certificate, :count).by(-1)
      end

      it 'redirects with success notice' do
        delete :destroy, params: { id: certificate.id, certificate_template_id: certificate_template.id }, headers: { "HTTP_REFERER" => certificate_templates_path }
        expect(response).to redirect_to(certificate_templates_path)
        expect(flash[:notice]).to eq(I18n.t('certificates.destroy.success'))
      end
    end

    context 'when certificate does not exist' do
      it 'does not change the Certificate count' do
        expect {
          delete :destroy, params: { id: 999, certificate_template_id: certificate_template.id }, headers: { "HTTP_REFERER" => certificate_templates_path }
        }.not_to change(Certificate, :count)
      end

      it 'redirects with alert' do
        delete :destroy, params: { id: 999, certificate_template_id: certificate_template.id }, headers: { "HTTP_REFERER" => certificate_templates_path }
        expect(response).to redirect_to(certificate_templates_path)
        expect(flash[:alert]).to eq(I18n.t('certificates.destroy.not_found'))
      end
    end
  end
end