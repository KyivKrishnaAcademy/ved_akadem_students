require 'rails_helper'

describe Ui::CertificatesController do
  Given(:create_params) { { assigned_cert_template_id: 1, student_profile_id: 1 } }
  Given(:create_action) { post :create, certificate: create_params, format: :json }
  Given(:parsed_response) { JSON.parse(response.body, symbolize_names: true) }

  describe 'not signed in' do
    context '#create' do
      When { create_action }

      include_examples :ui_not_authenticated
    end
  end

  describe 'signed in' do
    Given(:person) { create :person, roles: [create(:role, activities: activities)] }
    Given(:activities) { ['some'] }

    Given { sign_in person }

    context '#create' do
      When { create_action }

      describe 'as regular user' do
        include_examples :ui_not_authorized
      end

      describe 'with rights' do
        Given(:activities) { ['certificate:ui_create'] }

        context 'success' do
          Given(:create_params) do
            {
              assigned_cert_template_id: create(:assigned_cert_template).id,
              student_profile_id: person.create_student_profile.id
            }
          end

          Then { expect(parsed_response[:success]).to be(true) }
          And  { expect(response.status).to eq(200) }
          And  { expect(parsed_response[:errors]).to be_nil }
        end

        context 'failure' do
          Then { expect(parsed_response[:success]).to be(false) }
          And  { expect(response.status).to eq(422) }
          And  { expect(parsed_response[:errors]).to be_present }
        end
      end
    end
  end
end
