class PeopleController < ApplicationController
  include PersonSetable
  include CropDirectable
  include StudyApplicationable
  include ClassSchedulesRefreshable
  include CertificatesListable

  before_action :authenticate_person!, only: %i[show edit update destroy show_photo journal]
  before_action :set_person, only: %i[show edit update destroy show_photo journal]

  after_action :verify_authorized
  after_action :verify_policy_scoped, except: %i[new create]
  after_action :refresh_class_schedules_mv, only: :update

  layout 'person_tabs', only: %i[show journal]

  def index
    authorize Person

    @search_query = params.dig(:search, :query)

    @people = if params[:with_application].present?
      people_with_application
    elsif params[:without_application].present?
      people_without_application
    elsif @search_query.present?
      people_list.search(@search_query).page(params[:page])
    else
      people_list.page(params[:page])
    end
  end

  def show
    preset_applications_variables(@person)

    @academic_groups = AcademicGroup.active.select(:id, :title)
    student_profile = @person.student_profile

    preset_certificates(student_profile)

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

  def new
    @person = Person.new

    authorize @person

    @person.telephones.build
  end

  def edit; end

  def create
    @person = Person.new(PersonParams.filter(params).merge(skip_password_validation: true))

    authorize @person

    if @person.save
      redirect_to direct_to_crop(new_person_path, @person), flash: create_successed(@person)
    else
      render action: :new
    end
  end

  def journal
    @versions = GetPersonVersionsService.call(@person).page(params[:page])

    @version_authors =
      Person
        .where(id: @versions.map(&:whodunnit).uniq.compact)
        .index_by { |p| p.id.to_s }
  end

  def update
    if @person.update(PersonParams.filter(params).merge(skip_password_validation: true))
      flash[:success] = I18n.t('people.update_success')

      redirect_to direct_to_crop(person_path(@person), @person)
    else
      render action: :edit
    end
  end

  def destroy
    if @person.destroy
      flash[:success] = I18n.t('people.delete_success')
      redirect_to people_path
    else
      flash[:danger] = I18n.t('people.delete_failure')
      redirect_back fallback_location: root_path
    end

    # TODO: DRY the controller with responders
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

  class PersonParams
    def self.filter(params)
      params.require(:person).permit(
        :birthday, :email, :gender,
        :middle_name, :name, :photo, :photo_cache, :diploma_name,
        :surname, telephones_attributes: %i[id phone _destroy]
      )
    end
  end

  private

  def create_successed(person)
    { success: "#{view_context.link_to(person.complex_name, person_path(person))} added." }
  end
# TODO for security
  def people_list
    policy_scope(Person).order(Arel.sql("CASE WHEN (diploma_name IS NULL OR diploma_name = '') THEN (surname || name || middle_name) ELSE diploma_name END"))
  end

  def people_with_application
    people_list.with_application(params[:with_application]).page(params[:page])
  end

  def people_without_application
    policy_scope(Person).order(created_at: :desc).without_application.page(params[:page])
  end
end
