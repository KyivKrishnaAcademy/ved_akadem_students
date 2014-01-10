class AkademGroupsController < ApplicationController
  before_action :set_akadem_group, only: [:show, :edit, :update, :destroy]

  # GET /akadem_groups
  def index
    @akadem_groups = AkademGroup.all
  end

  # GET /akadem_groups/1
  def show
  end

  # GET /akadem_groups/new
  def new
    @akadem_group = AkademGroup.new(establ_date: Time.now)
  end

  # GET /akadem_groups/1/edit
  def edit
  end

  # POST /akadem_groups
  def create
    @akadem_group = AkademGroup.new(AkademGroupParams.filter(params))
    if @akadem_group.save
      flash[:success] = 'Akadem group was successfully created.'
      redirect_to action: :new
    else
      render      action: :new
    end
  end

  # PATCH/PUT /akadem_groups/1
  def update
    if @akadem_group.update_attributes(AkademGroupParams.filter(params))
      redirect_to @akadem_group, flash: {success: 'Akadem group was successfully updated.'}
    else
      render action: :edit
    end
  end

  # DELETE /akadem_groups/1
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
    # Use callbacks to share common setup or constraints between actions.
    def set_akadem_group
      @akadem_group = AkademGroup.find(params[:id])
    end
end
