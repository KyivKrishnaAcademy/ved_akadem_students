class AcademicGroupsController < HtmlRespondableController
  include AdvancedSearchable
  include ClassSchedulesRefreshable

  before_action :set_resource, only: %i[show edit update destroy graduate]

  after_action :verify_authorized
  after_action :verify_policy_scoped, only: %i[index show edit update destroy]
  after_action :refresh_class_schedules_mv, only: %i[destroy update graduate]

  def index
    authorize AcademicGroup

    @resource = policy_scope(AcademicGroup)

    advanced_search(
      params[:search]&.values || [],
      %w[title group_description],
      {
        'title' => 'title',
        'establ_date' => 'establ_date',
        'graduated_at' => "date_trunc('minute', graduated_at)",
        'group_description' => 'group_description'
      }
    )

    @groups_page = @resource.by_active_title.page(params[:page])
    @active_students_count = active_students_count(@groups_page.ids)
  end

  def show
    @examinations = examinations
    @examination_results = examination_results
    @people_for_attendance = people_for_attendance
  end

  def new
    @academic_group = AcademicGroup.new(establ_date: Time.zone.now)

    authorize @academic_group
  end

  def edit; end

  def create
    @academic_group = AcademicGroup.new(AcademicGroupParams.filter(params))

    authorize @academic_group

    @academic_group.save

    respond_with(@academic_group, location: new_academic_group_path)
  end

  def update
    @academic_group.update(AcademicGroupParams.filter(params))

    respond_with(@academic_group)
  end

  def destroy
    @academic_group.destroy

    respond_with(@academic_group)
  end

  def graduate
    @academic_group.graduate!
    @academic_group.group_participations.each(&:leave!)

    redirect_to academic_group_path(@academic_group), flash: { success: 'Academic group was successfully graduated.' }
  end

  class AcademicGroupParams
    def self.filter(params)
      params.require(:academic_group).permit(
        :title,
        :group_description,
        :message_ru,
        :message_uk,
        :administrator_id,
        :praepostor_id,
        :curator_id,
        :establ_date,
        course_ids: []
      )
    end
  end

  private

  def set_resource
    @academic_group = policy_scope(AcademicGroup).find(params[:id])

    authorize @academic_group
  end

  def people_for_attendance
    @academic_group
      .active_students
      .includes(:student_profile)
      .map do |p|
        photo_path = if p.photo.present?
          "/people/show_photo/standart/#{p.id}"
        else
          p.photo.versions[:standart].url
        end

        {
          name: p.short_name,
          photoPath: photo_path,
          studentProfileId: p.student_profile.id
        }
      end
  end

  def examination_results
    ExaminationResult
      .where(
        examination_id: @examinations.pluck(:id),
        student_profile_id: @academic_group.active_students.joins(:student_profile).map { |p| p.student_profile.id }
      )
      .map do |er|
        {
          id: er.id,
          score: er.score,
          examinationId: er.examination_id,
          studentProfileId: er.student_profile_id
        }
      end
  end

  def examinations
    @academic_group
      .examinations
      .includes(:course)
      .order(:course_id, :title)
      .map do |e|
        {
          id: e.id,
          title: e.title,
          maxResult: e.max_result,
          minResult: e.min_result,
          description: e.description,
          courseTitle: e.course.title,
          passingScore: e.passing_score
        }
      end
  end

  def active_students_count(group_ids)
    base =
      GroupParticipation
        .joins(:academic_group)
        .where(academic_group_id: group_ids)

    current_groups =
      base
        .where(academic_groups: { graduated_at: nil })
        .where(leave_date: nil)

    finished_groups =
      base
        .where.not(academic_groups: { graduated_at: nil })
        .where('leave_date >= academic_groups.graduated_at')

    current_groups
      .or(finished_groups)
      .group(:academic_group_id)
      .count
  end

  def flash_interpolation_options
    {
      link_or_name: link_or_name
    }
  end

  def link_or_name
    return unless @academic_group.persisted?

    title = @academic_group.title

    view_context.link_to_if(
      policy(@academic_group).show?,
      title,
      academic_group_path(@academic_group),
      class: 'alert-link'
    ) do
      title
    end
  end
end
