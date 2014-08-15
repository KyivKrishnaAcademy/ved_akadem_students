require 'spec_helper'

describe CropsController do
  describe :scope do
    Given { @person_1 = create :person, photo: File.open("#{Rails.root}/spec/fixtures/150x200.png") }

    context :own do
      When { sign_in :person, @person_1 }
      When { get :crop_image, id: @person_1.id }

      Then { assigns(:person).should eq(@person_1) }
      And  { response.status.should eq(200) }
    end

    context :has_rights do
      Given { @person_2 = create :person, roles: [create(:role, activities: %w{person:crop_image})]}

      When { sign_in :person, @person_2 }
      When { get :crop_image, id: @person_1.id }

      Then { assigns(:person).should eq(@person_1) }
      And  { response.status.should eq(200) }
    end

    context :no_rights do
      Given { @person_2 = create :person }
      Given { request.env['HTTP_REFERER'] = 'where_i_came_from' }

      When { sign_in :person, @person_2 }
      When { get :crop_image, id: @person_1.id }

      Then { response.should redirect_to('where_i_came_from') }
    end
  end
end
