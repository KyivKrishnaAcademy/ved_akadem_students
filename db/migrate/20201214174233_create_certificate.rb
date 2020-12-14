class CreateCertificate < ActiveRecord::Migration[5.0]
  def change
    create_table :certificates do |t|
      t.references :academic_group, foreign_key: true
      t.references :certificate_template, foreign_key: true
      t.references :student_profile, foreign_key: true
      t.datetime :issued_date
      t.string :serial_id
      t.integer :final_score
    end

    add_index :certificates, :serial_id, unique: true
  end
end
