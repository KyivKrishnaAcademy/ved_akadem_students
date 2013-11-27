class PeopleController < ApplicationController

  def new
    @person = Person.new
  end

  def create
    @person = Person.new(params.require(:person).permit(
        :name           ,
        :spiritual_name ,
        :middle_name    ,
        :surname        ,
        :email          ,
        :telephone      ,
        :gender         ,
        :birthday       ,
        :edu_and_work   ,
        :emergency_contact
      ))
    if @person.save
      flash[:success] = "#{view_context.complex_name(@person)} added."
      redirect_to(action: :new)
    elsif
      render(action: :new)
    end

  end

end
