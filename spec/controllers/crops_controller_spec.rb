require 'rails_helper'

describe CropsController do
  describe 'scope' do
    Given(:person_with_photo) { create :person, :with_photo }

    context 'own' do
      When { sign_in :person, person_with_photo }
      When { get :crop_image, id: person_with_photo.id }

      Then { expect(assigns(:person)).to eq(person_with_photo) }
      And  { expect(response.status).to eq(200) }
    end

    context 'has_rights' do
      Given(:person_with_right) { create :person, roles: [create(:role, activities: %w(person:crop_image))] }

      When { sign_in :person, person_with_right }
      When { get :crop_image, id: person_with_photo.id }

      Then { expect(assigns(:person)).to eq(person_with_photo) }
      And  { expect(response.status).to eq(200) }
    end

    context 'no_rights' do
      Given(:person_without_right) { create :person }

      Given { request.env['HTTP_REFERER'] = '/where_i_came_from' }

      When { sign_in :person, person_without_right }
      When { get :crop_image, id: person_with_photo.id }

      Then { expect(response.status).to redirect_to('/where_i_came_from') }
    end
  end

  describe '#update_image' do
    Given(:person) { mock_model Person }

    Given { allow(Person).to receive(:find).with('2').and_return(person) }

    When { sign_in :person, create(:person, roles: [create(:role, activities: %w(person:crop_image))]) }
    When { get :update_image, person: { crop_x: 0 }, id: 2 }

    context 'cropped' do
      Given { allow(person).to receive(:crop_photo).and_return(true) }

      describe 'flash and variable' do
        Then { expect(assigns(:person)).to eq(person) }
      end

      describe 'redirect' do
        context 'session[:after_crop_path] is set' do
          Given { session[:after_crop_path] = '/some_path' }

          Then  { expect(response.status).to redirect_to('/some_path') }
        end

        context 'session[:after_crop_path] is not set' do
          Then  { expect(response.status).to redirect_to('/') }
        end
      end
    end

    context 'not cropped' do
      Given { allow(person).to receive(:crop_photo).and_return(false) }

      Then  { expect(assigns(:person)).to eq(person) }
      And   { is_expected.to set_flash[:danger] }
      And   { expect(response.status).to render_template('crop_image') }
    end
  end
end
