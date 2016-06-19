class CreateCertificates < ActiveRecord::Migration
  def change
    create_table :certificates do |t|
      t.references :student_profile, foreign_key: true
      t.references :assigned_cert_template, foreign_key: true
      t.string :cert_id

      t.index [:assigned_cert_template_id, :student_profile_id], unique: true,
        name: :index_assigned_template_id_profile_id

      t.timestamps null: false
    end
  end
end
