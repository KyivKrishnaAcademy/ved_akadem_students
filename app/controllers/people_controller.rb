class PeopleController < ApplicationController

  def add
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
      #TODO write flash message
      flash[:success] = "yohoo!"
      redirect_to(action: :add)
    elsif
      #TODO write flash message
      flash[:danger] = "error!"
      render(action: :add)
    end

  end

end
