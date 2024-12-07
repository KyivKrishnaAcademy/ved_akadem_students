class AddColorToCertificateTemplateEntries < ActiveRecord::Migration[5.0]
  def change
    add_column :certificate_template_entries, :color, :string, default: "#000000", null: false
  end
end
