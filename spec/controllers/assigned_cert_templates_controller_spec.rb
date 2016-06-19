require 'rails_helper'

describe AssignedCertTemplatesController do
  describe 'not signed in' do
    context '#create' do
      When  { post :create, assigned_cert_template: { academic_group_id: 1, certificate_template_id: 2 } }

      it_behaves_like :not_authenticated
    end
  end

  describe 'signed in' do
    Given(:group) { create :academic_group }
    Given(:person) { create :person, roles: [create(:role, activities: activities)] }
    Given(:template) { create :certificate_template }
    Given(:activities) { ['some'] }
    Given(:create_action) do
      post :create, assigned_cert_template: {
        academic_group_id: group.id, certificate_template_id: template.id
      }
    end

    Given { sign_in person }

    describe 'regular user' do
      describe '#create' do
        context 'not authorized' do
          When  { create_action }

          include_examples :not_authorized
        end

        context 'should not create' do
          Then { expect {create_action}.not_to change {AssignedCertTemplate.count} }
        end
      end
    end
  end
end
