class AddCertificatesCountToCertificateTemplates < ActiveRecord::Migration[5.0]
  def change
    add_column :certificate_templates, :certificates_count, :integer, default: 0
  end
end
