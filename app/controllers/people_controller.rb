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
      flash[:success] = "#{view_context.link_to( view_context.complex_name(@person), person_path(@person) )} added.".html_safe
      redirect_to(action: :new)
    elsif
      render(action: :new)
    end
  end

  def show
    @person = Person.find(params[:id])
  end

  def index
    @people = Person.all
  end

  def destroy
    if Person.find(params[:id]).destroy.destroyed?
      flash[:success] = "Person record deleted!"
      redirect_to people_path
    else
      flash[:error] = "Person deletion failed!"
      redirect_to :back
    end
  end
end
