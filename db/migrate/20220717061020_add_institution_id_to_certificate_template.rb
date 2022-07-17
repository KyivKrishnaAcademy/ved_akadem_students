class AddInstitutionIdToCertificateTemplate < ActiveRecord::Migration[5.0]
  def change
    add_reference :certificate_templates, :institution, index: true
  end
end
