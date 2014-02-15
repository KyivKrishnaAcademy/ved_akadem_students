require 'spec_helper'

describe PeopleController do
  before { sign_in :person, create(:person) }

  it_behaves_like "POST 'create'", :person, Person
  it_behaves_like "GET"          , :person, Person, :new
  it_behaves_like "GET"          , :person, Person, :show
  it_behaves_like "GET"          , :person, Person, :edit
  it_behaves_like "GET"          , :people, Person, :index
  it_behaves_like "DELETE 'destroy'", Person
  it_behaves_like "PATCH 'update'", Person, :emergency_contact

  let(:mod_params) do
    {
      name:               "Василий"               ,
      spiritual_name:     "Сарва Сатья дас"       ,
      middle_name:        "Тигранович"            ,
      surname:            "Киселев"               ,
      email:              "ssd@pamho.yes"         ,
      telephone:          "380112223344"          ,
      gender:             true                    ,
      birthday:           7200.days.ago.to_date   ,
      edu_and_work:       "ББТ"                   ,
      emergency_contact:  "Харе Кришна Харе Кришна Кришна Кришна Харе Харе"
    }
  end

  it_behaves_like "controller subclass", PeopleController::PersonParams, :person
end
