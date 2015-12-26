class CreateCertificates < ActiveRecord::Migration
  def change
    create_table :certificates do |t|
      t.references :student_profile, index: true, foreign_key: true
      t.references :assigned_cert_template, index: true, foreign_key: true
      t.string :cert_id

      t.timestamps null: false
    end
  end
end
