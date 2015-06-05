class PeopleController < ApplicationController
  include CropDirectable
  include StudyApplicationable

  before_action :set_person, only: [:show, :edit, :update, :destroy, :show_photo,
                                    :show_passport, :move_to_group, :remove_from_groups]

  after_action :verify_authorized
  after_action :verify_policy_scoped, except: [:new, :create]

  def new
    @person = Person.new

    authorize @person

    @person.telephones.build
  end

  def create
    @person = Person.new(PersonParams.filter(params).merge(skip_password_validation: true))

    authorize @person

    if @person.save
      redirect_to direct_to_crop(new_person_path, @person), flash: create_successed(@person)
    else
      render action: :new
    end
  end

  def show
    preset_applications_variables(@person)

    @academic_groups = AcademicGroup.where(graduated_at: nil).select(:id, :title).order(:title)
  end

  def edit
  end

  def index
    authorize Person

    @people = policy_scope(Person).by_complex_name.page(params[:page])
  end

  def destroy
    if @person.destroy.destroyed?
      redirect_to people_path, flash: { success: 'Person record deleted!' }
    else
      redirect_to :back, flash: { danger: 'Person deletion failed!' }
    end

    #TODO DRY the controller with responders
  end

  def update
    if @person.update_attributes(PersonParams.filter(params).merge(skip_password_validation: true))
      flash[:success] = 'Person was successfully updated.'

      redirect_to direct_to_crop(person_path(@person), @person)
    else
      render action: :edit
    end
  end

  def show_photo
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
    send_file(@person.passport_url,
              disposition: 'inline',
              type: 'image/jpeg',
              x_sendfile: true)
  end

  def move_to_group
    if (@academic_group = AcademicGroup.find(params[:group_id]))
      (@person.student_profile || @person.create_student_profile).move_to_group(@academic_group)
    else
      render nothing: true
    end
  end

  def remove_from_groups
    @person.student_profile.remove_from_groups if @person.student_profile.present?
  end

  class PersonParams
    def self.filter(params)
      params.require(:person).permit(
        :birthday, :education, :email, :emergency_contact, :friends_to_be_with, :gender, :marital_status,
        :middle_name, :name, :passport, :passport_cache, :photo, :photo_cache, :spiritual_name,
        :surname, :work, :special_note, telephones_attributes: [:id, :phone, :_destroy]
      )
    end
  end

  private

  def set_person
    @person = policy_scope(Person).find(params[:id])

    authorize @person
  end

  def create_successed(person)
    { success: "#{view_context.link_to(person.complex_name, person_path(person))} added.".html_safe }
  end
end
