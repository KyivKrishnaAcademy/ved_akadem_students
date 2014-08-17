require 'spec_helper'

describe Users::RegistrationsController do
  Given { request.env["devise.mapping"] = Devise.mappings[:person] }

  When { sign_in :person, @person }

  shared_examples_for :hide_person do
    When { delete :destroy }

    Then do
      @person.reload
      @person.email.should =~ /^\w{6}.deleted.some@example.com$/
      @person.deleted.should be_true
    end
  end

  describe 'destroy' do
    context 'person is not a student or teacher' do
      Given { @person = create :person }

      Then  { expect { delete :destroy }.to change(Person, :count).by(-1) }
    end

    context 'person is student' do
      Given { @person = create :person, :student, email: 'some@example.com' }

      it_behaves_like :hide_person
    end

    context 'person is student' do
      Given { @person = create :person, :teacher, email: 'some@example.com' }

      it_behaves_like :hide_person
    end
  end
end
