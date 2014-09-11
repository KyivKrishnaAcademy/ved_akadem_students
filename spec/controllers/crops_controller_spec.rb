require 'spec_helper'

describe CropsController do
  describe :scope do
    Given { @person_1 = create :person, :with_photo }

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
      Given { request.env['HTTP_REFERER'] = '/where_i_came_from' }

      When { sign_in :person, @person_2 }
      When { get :crop_image, id: @person_1.id }

      Then { response.should redirect_to('/where_i_came_from') }
    end
  end

  describe '#update_image' do
    Given(:person) { mock_model Person }
    Given { Person.stub(:find).with('2').and_return(person) }

    When { sign_in :person, create(:person, roles: [create(:role, activities: %w{person:crop_image})]) }
    When { get :update_image, { person: { crop_x: 0 }, id: 2 } }

    context 'cropped' do
      Given { person.stub(:crop_photo).and_return(true) }

      describe 'flash and variable' do
        Then  do
          assigns(:person).should == person
          should set_the_flash[:success]
        end
      end

      describe 'redirect' do
        context 'session[:after_crop_path] is set' do
          Given { session[:after_crop_path] = '/some_path' }

          Then  { response.should redirect_to('/some_path') }
        end

        context 'session[:after_crop_path] is not set' do
          Then  { response.should redirect_to('/') }
        end
      end
    end

    context 'not cropped' do
      Given { person.stub(:crop_photo).and_return(false) }

      Then  do
        assigns(:person).should == person
        should set_the_flash[:danger]
        response.should render_template('crop_image')
      end
    end
  end
end
