require 'rails_helper'

describe CoursesController do
  describe 'not signed in' do
    it_behaves_like :failed_auth_crud, :not_authenticated
  end

  describe 'signed in' do
    Given(:person) { build_stubbed(:person, id: 1) }
    Given(:course) { build_stubbed(:course, id: 1) }

    Given { allow(request.env['warden']).to receive(:authenticate!) { person } }
    Given { allow(controller).to receive(:current_person) { person } }
    Given { allow(person).to receive(:class).and_return(Person) }

    Given { allow(Course).to receive(:find).with('1').and_return(course) }

    describe 'as regular user' do
      describe '#index' do
        When { get :index }

        it_behaves_like :not_authorized, 'index'
      end

      describe '#show' do
        When { get :show, id: 1 }

        it_behaves_like :not_authorized, 'show'
      end
    end
  end
end
