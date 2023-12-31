class CreateCertificateTemplateImages < ActiveRecord::Migration[5.0]
  def change
    create_table :certificate_template_images do |t|
      t.references :certificate_template, foreign_key: true
      t.references :signature, foreign_key: true
      t.float :scale, default: 1.0
      t.integer :x, default: 0
      t.integer :y, default: 0
      t.float :angle, default: 0.0

      t.timestamps
    end
  end
end
