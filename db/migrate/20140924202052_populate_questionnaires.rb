class PopulateQuestionnaires < ActiveRecord::Migration
  def up
    Questionnaire.destroy_all

    Rake::Task['akadem:create_questionnaires'].invoke
  end
end
