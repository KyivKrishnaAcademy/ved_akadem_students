require 'rails_helper'

RSpec.describe CertificatesController, type: :controller do
  let(:certificate_template) { create(:certificate_template) }
  let!(:certificate) { create(:certificate, certificate_template: certificate_template) }
  let(:unauthorized_user) { create(:person, roles: [create(:role, name: 'unauthorized')]) }
  let(:user) { create(:person, roles: [create(:role, name: 'authorized', activities: ['certificate:destroy'])]) }

  describe 'DELETE #destroy' do
    context 'when user is not logged in' do
      before do
        sign_out user # Make sure the user is not authorized
      end

      it 'does not delete the certificate' do
        expect do
          delete :destroy, params: { id: certificate.id, certificate_template_id: certificate_template.id }
        end.not_to change(Certificate, :count)
      end

      it 'redirects to the login page' do
        delete :destroy, params: { id: certificate.id, certificate_template_id: certificate_template.id }
        expect(response).to redirect_to(new_person_session_path)
      end
    end

    context 'when user is unauthorized' do
      before do
        sign_in unauthorized_user
        request.env['HTTP_REFERER'] = root_path
      end

      it 'does not delete the certificate' do
        expect do
          delete :destroy, params: { id: certificate.id, certificate_template_id: certificate_template.id }
        end.not_to change(Certificate, :count)
      end

      it 'redirects to the root path' do
        delete :destroy, params: { id: certificate.id, certificate_template_id: certificate_template.id }
        expect(response).to redirect_to(root_path)
      end
    end

    context 'when user is authorized' do
      before do
        sign_in user
        request.env['HTTP_REFERER'] = certificate_templates_path
      end

      it 'deletes the certificate' do
        expect do
          delete :destroy, params: { id: certificate.id, certificate_template_id: certificate_template.id }
        end.to change(Certificate, :count).by(-1)
      end

      it 'redirects to the certificate templates path' do
        delete :destroy, params: { id: certificate.id, certificate_template_id: certificate_template.id }
        expect(response).to redirect_to(certificate_templates_path)
      end
    end
  end
end