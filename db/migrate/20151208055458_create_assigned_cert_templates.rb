class CreateAssignedCertTemplates < ActiveRecord::Migration
  def change
    create_table :assigned_cert_templates, id: false do |t|
      t.integer :academic_group_id
      t.integer :certificate_template_id

      t.index [:academic_group_id, :certificate_template_id],
        unique: true, name: :index_group_id_cert_template_id

      t.timestamps null: false
    end

  end
end
