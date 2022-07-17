class AddProgramTypeToCertificateTemplate < ActiveRecord::Migration[5.0]
  def change
    add_column :certificate_templates, :program_type, :integer, default: 0
  end
end
