class AcademicGroupsController < ApplicationController
  include ClassSchedulesRefreshable

  before_action :set_resource, only: [:show, :edit, :update, :destroy, :graduate]

  after_action :verify_authorized
  after_action :verify_policy_scoped, only: %i(index show edit update destroy)
  after_action :refresh_class_schedules_mv, only: %i(destroy update graduate)

  def index
    @academic_groups = policy_scope(AcademicGroup).by_active_title

    authorize AcademicGroup
  end

  def show
    @cert_templates = CertificateTemplate.not_assigned_to(@academic_group.id)
  end

  def new
    @academic_group = AcademicGroup.new(establ_date: Time.now)

    authorize @academic_group
  end

  def edit
  end

  def create
    @academic_group = AcademicGroup.new(AcademicGroupParams.filter(params))

    authorize @academic_group

    #TODO DRY the controller with responders
    if @academic_group.save
      flash[:success] = "#{view_context.link_to(@academic_group.title,
                                                academic_group_path(@academic_group))} added."

      redirect_to action: :new
    else
      render action: :new
    end
  end

  def update
    if @academic_group.update_attributes(AcademicGroupParams.filter(params))
      redirect_to @academic_group, flash: { success: 'Academic group was successfully updated.' }
    else
      render action: :edit
    end
  end

  def destroy
    if @academic_group.destroy.destroyed?
      redirect_to academic_groups_path, flash: { success: 'Academic Group record deleted!' }
    else
      redirect_to :back, flash: { danger: 'Academic Group deletion failed!' }
    end
  end

  def graduate
    @academic_group.graduate!

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
        :establ_date
      )
    end
  end

  private

  def set_resource
    @academic_group = policy_scope(AcademicGroup).find(params[:id])

    authorize @academic_group
  end
end
