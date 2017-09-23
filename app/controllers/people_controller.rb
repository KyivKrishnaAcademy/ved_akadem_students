class PeopleController < ApplicationController
  include PersonSetable
  include CropDirectable
  include StudyApplicationable
  include ClassSchedulesRefreshable

  before_action :set_person, only: %i(show edit update destroy show_photo show_passport)

  after_action :verify_authorized
  after_action :verify_policy_scoped, except: %i(new create)
  after_action :refresh_class_schedules_mv, only: :update

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

    @academic_groups = AcademicGroup.active.select(:id, :title)

    student_profile = @person.student_profile

    @prev_group_participations = if student_profile.present?
      student_profile
        .group_participations
        .includes(:academic_group)
        .where.not(leave_date: nil)
        .order(:join_date, :leave_date)
    else
      []
    end
  end

  def edit
  end

  def index
    authorize Person

    @people = if params[:with_application].present?
      people_list.with_application(params[:with_application]).page(params[:page])
    elsif params[:without_application].present?
      policy_scope(Person).order(created_at: :desc).without_application.page(params[:page])
    else
      people_list.page(params[:page])
    end
  end

  def destroy
    if @person.destroy.destroyed?
      redirect_to people_path, flash: { success: 'Person record deleted!' }
    else
      redirect_back fallback_location: root_path, flash: { danger: 'Person deletion failed!' }
    end

    # TODO: DRY the controller with responders
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

    send_file(
      path,
      disposition: 'inline',
      type: 'image/jpeg',
      x_sendfile: true
    )
  end

  def show_passport
    send_file(
      @person.passport_url,
      disposition: 'inline',
      type: 'image/jpeg',
      x_sendfile: true
    )
  end

  class PersonParams
    def self.filter(params)
      params.require(:person).permit(
        :birthday, :education, :email, :emergency_contact, :friends_to_be_with, :gender, :marital_status,
        :middle_name, :name, :passport, :passport_cache, :photo, :photo_cache, :spiritual_name, :diksha_guru,
        :surname, :work, :special_note, telephones_attributes: [:id, :phone, :_destroy]
      )
    end
  end

  private

  def create_successed(person)
    { success: "#{view_context.link_to(person.complex_name, person_path(person))} added." }
  end

  def people_list
    policy_scope(Person).by_complex_name
  end
end
