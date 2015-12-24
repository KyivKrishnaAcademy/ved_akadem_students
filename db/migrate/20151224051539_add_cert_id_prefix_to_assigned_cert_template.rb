class AddCertIdPrefixToAssignedCertTemplate < ActiveRecord::Migration
  def change
    add_column :assigned_cert_templates, :cert_id_prefix, :string, null: false
  end
end
