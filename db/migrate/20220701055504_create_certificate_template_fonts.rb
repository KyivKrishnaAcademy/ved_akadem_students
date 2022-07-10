class CreateCertificateTemplateFonts < ActiveRecord::Migration[5.0]
  def change
    create_table :certificate_template_fonts do |t|
      t.string :name
      t.string :file

      t.timestamps
    end
    add_index :certificate_template_fonts, :name, unique: true
  end
end
