class PeopleController < ApplicationController
  before_action :set_person, only: [:show, :edit, :update, :destroy]

  def new
    @person = Person.new
  end

  def create
    @person = Person.new(PersonParams.filter(params))
    if @person.save
      flash[:success] = "#{view_context.link_to( view_context.complex_name(@person), person_path(@person) )} added.".html_safe
      redirect_to action: :new
    elsif
      render      action: :new
    end
  end

  def show
  end

  def edit
  end

  def index
    @people = Person.all
  end

  def destroy
    if @person.destroy.destroyed?
      redirect_to people_path , flash: { success: 'Person record deleted!'  }
    else
      redirect_to :back       , flash: { error:   'Person deletion failed!' }
    end
  end

  def update
    if @person.update_attributes(PersonParams.filter(params))
      redirect_to @person, flash: { success: 'Person was successfully updated.' }
    else
      render      action: :edit
    end
  end

  class PersonParams
    def self.filter params
      params.require(:person).permit(
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
      )
    end
  end

  private
    def set_person
      @person = Person.find(params[:id])
    end
end
