class GroupParticipationsController < ApplicationController
  before_action :set_resource, only: [:destroy]

  after_action :verify_authorized

  def destroy
    params[:leave] ? @group_participation.leave! : @group_participation.destroy

    redirect_to @group_participation.student_profile.person
  end

  private

  def set_resource
    @group_participation = GroupParticipation.find(params[:id])

    authorize @group_participation
  end
end
