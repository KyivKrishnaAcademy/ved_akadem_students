class PeopleController < ApplicationController
  def add
    @person = Person.new
  end

  def create
    #@person = Person.new(params.require(:person).permit(:name))
    #@person.save
    redirect_to(action: :add)
  end
end
