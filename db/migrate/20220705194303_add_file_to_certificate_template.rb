class AddFileToCertificateTemplate < ActiveRecord::Migration[5.0]
  def change
    add_column :certificate_templates, :file, :string
  end
end
