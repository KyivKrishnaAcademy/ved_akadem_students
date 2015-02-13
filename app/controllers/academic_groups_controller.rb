class AcademicGroupsController < ApplicationController
  before_action :set_academic_group, only: [:show, :edit, :update, :destroy]

  after_action :verify_authorized
  after_action :verify_policy_scoped, only: [:index, :show, :edit, :update, :destroy]

  autocomplete :person, :complex_name, full: true

  def autocomplete_person
    authorize AcademicGroup

    autocomplete_person_complex_name
  end

  def index
    @akadem_groups = policy_scope(AcademicGroup)

    authorize AcademicGroup
  end

  def show
  end

  def new
    @akadem_group = AcademicGroup.new(establ_date: Time.now)

    authorize @akadem_group
  end

  def edit
  end

  def create
    @akadem_group = AcademicGroup.new(AcademicGroupParams.filter(params))

    authorize @akadem_group

    if @akadem_group.save
      flash[:success] = "#{view_context.link_to(@akadem_group.group_name,
                                                akadem_group_path(@akadem_group))} added.".html_safe

      redirect_to action: :new
    else
      render action: :new
    end
  end

  def update
    if @akadem_group.update_attributes(AcademicGroupParams.filter(params))
      redirect_to @akadem_group, flash: { success: 'Akadem group was successfully updated.' }
    else
      render action: :edit
    end
  end

  def destroy
    if @akadem_group.destroy.destroyed?
      redirect_to akadem_groups_path, flash: { success: 'Akadem Group record deleted!' }
    else
      redirect_to :back, flash: { danger: 'Akadem Group deletion failed!' }
    end
  end

  class AcademicGroupParams
    def self.filter(params)
      params.require(:akadem_group).permit(
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

  def set_academic_group
    @akadem_group = policy_scope(AcademicGroup).find(params[:id])

    authorize @akadem_group
  end
end
