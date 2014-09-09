class AnswersController < ApplicationController
  inherit_resources
  defaults resource_class: Questionnaire, collection_name: :questionnaires, instance_name: :questionnaire
  actions :edit, :update

  after_filter :verify_authorized

  def edit
    authorize resource, :show_form?

    edit!
  end

  def update
    authorize resource, :save_answers?

    update!
  end

  private

  def begin_of_association_chain
    Pundit.policy(current_person, Questionnaire).update_all? ? super : current_person
  end
end
