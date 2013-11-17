class PeopleController < ApplicationController
  def add
    @person = Person.new
  end
end
