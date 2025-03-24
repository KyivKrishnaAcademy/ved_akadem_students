class AddIsFinalScoreRequiredToCertificateTemplates < ActiveRecord::Migration[5.0]
  def change
    add_column :certificate_templates, :is_final_score_required, :boolean, default: false
  end
end
