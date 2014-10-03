class AnswersController < ApplicationController
  inherit_resources
  defaults resource_class: Questionnaire, collection_name: :questionnaires, instance_name: :questionnaire
  actions :edit, :update

  after_filter :verify_authorized

  def edit
    authorize resource, :show_form?

    resource.questions.each { |q| q.answers.find_or_initialize_by(person: current_person) }

    edit!
  end

  def update
    authorize resource, :save_answers?

    update! do |success, failure|
      success.html do
        resource.complete!(current_person.id)

        redirect_to root_path
      end
    end
  end

  private

  def begin_of_association_chain
    Pundit.policy(current_person, Questionnaire).update_all? ? super : current_person
  end

  def permitted_params
    params.permit(:id, questionnaire: [
      questions_attributes: [
        :id,
        answers_attributes: [:id, :person_id, :data]
      ]
    ])
  end
end
