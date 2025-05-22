class DirectGroupCoursesRelation < ActiveRecord::Migration[5.0]
  def up
    create_join_table :academic_groups, :courses do |t|
      t.index [:academic_group_id, :course_id], name: 'index_academic_groups_courses_on_group_id_and_course_id'
      t.index [:course_id, :academic_group_id], name: 'index_academic_groups_courses_on_course_id_and_group_id'
    end

    if ActiveRecord::Base.connection.table_exists?(:academic_groups_programs) &&
       ActiveRecord::Base.connection.table_exists?(:courses_programs)
      
      sql = <<-SQL.squish
        SELECT academic_groups_programs.academic_group_id, courses_programs.course_id
        FROM academic_groups_programs
        INNER JOIN courses_programs ON courses_programs.program_id=academic_groups_programs.program_id;
      SQL

      values = ActiveRecord::Base.connection.execute(sql).map { |r| "(#{r.values.join(', ')})" }.join(", ")

      unless values.empty?
        insert_sql = "INSERT INTO academic_groups_courses (academic_group_id, course_id) VALUES #{values};"
        ActiveRecord::Base.connection.execute(insert_sql)
      end

      drop_join_table :academic_groups, :programs
      drop_join_table :courses, :programs
    end
  end

  def down
    drop_join_table :academic_groups, :courses
  end
end
