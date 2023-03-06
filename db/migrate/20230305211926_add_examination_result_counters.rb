class AddExaminationResultCounters < ActiveRecord::Migration[5.0]
  def change
    add_column :examinations, :examination_results_count, :integer, default: 0
    add_column :courses, :examination_results_count, :integer, default: 0
  end
end
