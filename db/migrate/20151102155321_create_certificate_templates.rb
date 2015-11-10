class CreateCertificateTemplates < ActiveRecord::Migration
  def change
    create_table :certificate_templates do |t|
      t.integer :status, null: false, default: 0
      t.integer :background_height, null: false, default: 0
      t.integer :background_width, null: false, default: 0
      t.string :background
      t.string :title
      t.jsonb :fields, null: false, default: '{}'

      t.timestamps null: false
    end

    add_index :certificate_templates, :status
  end
end
