class AcademicGroupsController < ApplicationController
  include Crudable

  after_action :verify_policy_scoped, only: [:index, :show, :edit, :update, :destroy]

  def index
    @academic_groups = policy_scope(AcademicGroup)

    authorize AcademicGroup
  end

  def show
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
      flash[:success] = "#{view_context.link_to(@academic_group.group_name,
                                                academic_group_path(@academic_group))} added.".html_safe

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

  class AcademicGroupParams
    def self.filter(params)
      params.require(:academic_group).permit(
        :group_name,
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
