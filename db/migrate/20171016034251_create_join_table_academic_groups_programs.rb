class CreateJoinTableAcademicGroupsPrograms < ActiveRecord::Migration[5.0]
  def up
    create_table :academic_groups_programs, id: false do |t|
      t.integer :academic_group_id, null: false
      t.integer :program_id, null: false

      t.index [:academic_group_id, :program_id], name: 'index_academic_groups_programs_on_group_id_and_program_id', unique: true
      t.index [:program_id, :academic_group_id], name: 'index_academic_groups_programs_on_program_id_and_group_id'
    end
  end

  def down
    drop_table :academic_groups_programs, if_exists: true
  end
end
