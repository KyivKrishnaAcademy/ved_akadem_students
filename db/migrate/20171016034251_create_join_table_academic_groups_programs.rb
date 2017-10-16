class CreateJoinTableAcademicGroupsPrograms < ActiveRecord::Migration[5.0]
  def change
    create_join_table :academic_groups, :programs do |t|
      t.index [:academic_group_id, :program_id], name: 'index_academic_groups_programs_on_group_id_and_program_id'
      t.index [:program_id, :academic_group_id], name: 'index_academic_groups_programs_on_program_id_and_group_id'
    end
  end
end
