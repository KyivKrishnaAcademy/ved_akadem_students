class CreateCertificateTemplateEntries < ActiveRecord::Migration[5.0]
  def change
    create_table :certificate_template_entries do |t|
      t.string :template
      t.references :certificate_template, foreign_key: true,
                                          index: { name: 'index_certificate_template_entries_on_template_id' }
      t.references :certificate_template_font, foreign_key: true,
                                               index: { name: 'index_certificate_template_entries_on_font_id' }
      t.float :character_spacing, default: 0.5
      t.integer :x, default: 0
      t.integer :y, default: 0
      t.integer :font_size, default: 16
      t.integer :align, default: 0

      t.timestamps
    end
  end
end
