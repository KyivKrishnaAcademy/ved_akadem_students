class AkademGroupsController < ApplicationController
  before_action :set_akadem_group, only: [:show, :edit, :update, :destroy]

  def index
    @akadem_groups = AkademGroup.all
  end

  def show
  end

  def new
    @akadem_group = AkademGroup.new(establ_date: Time.now)
  end

  def edit
  end

  def create
    @akadem_group = AkademGroup.new(AkademGroupParams.filter(params))
    if @akadem_group.save
      flash[:success] = "#{view_context.link_to( @akadem_group.group_name, akadem_group_path(@akadem_group) )} added.".html_safe
      redirect_to action: :new
    else
      render      action: :new
    end
  end

  def update
    if @akadem_group.update_attributes(AkademGroupParams.filter(params))
      redirect_to @akadem_group, flash: {success: 'Akadem group was successfully updated.'}
    else
      render action: :edit
    end
  end

  def destroy
    if @akadem_group.destroy.destroyed?
      redirect_to akadem_groups_path, flash: { success: 'Akadem Group record deleted!'  }
    else
      redirect_to :back, flash: { error: 'Akadem Group deletion failed!' }
    end
  end

  class AkademGroupParams
    def self.filter params
      params.require(:akadem_group).permit(
        :group_name        ,
        :group_description ,
        :establ_date
      )
    end
  end

  private
    def set_akadem_group
      @akadem_group = AkademGroup.find(params[:id])
    end
end
