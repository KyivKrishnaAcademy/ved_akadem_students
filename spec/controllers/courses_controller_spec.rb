require 'rails_helper'

describe CoursesController do
  describe 'not signed in' do
    it_behaves_like :not_authenticated_crud
  end
end
