class RemoveUnneededFieldsFromCertificateTemplates < ActiveRecord::Migration[5.0]
  def change
    remove_index :certificate_templates, :status

    remove_column :certificate_templates, :fields, :jsonb, null: false, default: {}
    remove_column :certificate_templates, :background, :string
    remove_column :certificate_templates, :background_width, :integer, null: false, default: 0
    remove_column :certificate_templates, :background_height, :integer, null: false, default: 0
    remove_column :certificate_templates, :status, :integer, null: false, default: 0
  end
end
