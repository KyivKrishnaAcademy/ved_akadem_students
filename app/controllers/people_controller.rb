class PeopleController < ApplicationController
  include CropDirectable
  include StudyApplicationable

  before_action :set_person, only: [:show, :edit, :update, :destroy, :show_photo, :show_passport]

  after_filter :verify_authorized
  after_filter :verify_policy_scoped, except: [:new, :create]

  def new
    @person = Person.new

    authorize @person

    @person.telephones.build
  end

  def create
    @person = Person.new(PersonParams.filter(params).merge(skip_password_validation: true))

    authorize @person

    if @person.save
      flash[:success] = "#{view_context.link_to( view_context.complex_name(@person), person_path(@person) )} added.".html_safe

      redirect_to direct_to_crop(new_person_path, @person)
    elsif
      render action: :new
    end
  end

  def show
    authorize @person

    set_programs_and_new_application(@person)
  end

  def edit
    authorize @person
  end

  def index
    @people = policy_scope(Person)

    authorize Person
  end

  def destroy
    authorize @person

    if @person.destroy.destroyed?
      redirect_to people_path, flash: { success: 'Person record deleted!' }
    else
      redirect_to :back, flash: { danger: 'Person deletion failed!' }
    end
  end

  def update
    authorize @person

    if @person.update_attributes(PersonParams.filter(params).merge(skip_password_validation: true))
      flash[:success] = 'Person was successfully updated.'

      redirect_to direct_to_crop(person_path(@person), @person)
    else
      render      action: :edit
    end
  end

  def show_photo
    authorize @person

    path = if params[:version] == 'default'
             @person.photo_url
           else
             @person.photo.versions[params[:version].to_sym].url
           end

    send_file(path,
              disposition: 'inline',
              type: 'image/jpeg',
              x_sendfile: true)
  end

  def show_passport
    authorize @person

    send_file(@person.passport_url,
              disposition: 'inline',
              type: 'image/jpeg',
              x_sendfile: true)
  end

  class PersonParams
    def self.filter(params)
      params.require(:person).permit(
        :birthday       ,
        :education      ,
        :email          ,
        :emergency_contact,
        :friends_to_be_with,
        :gender         ,
        :marital_status ,
        :middle_name    ,
        :name           ,
        :passport       ,
        :passport_cache ,
        :photo          ,
        :photo_cache    ,
        :spiritual_name ,
        :surname        ,
        :work           ,
        telephones_attributes: [:id, :phone, :_destroy]
      )
    end
  end

  private

  def set_person
    @person = policy_scope(Person).find(params[:id])
  end
end
