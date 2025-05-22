class AddCourseViewRoleToExistingStudents < ActiveRecord::Migration[5.0]
  def up
    Person.joins(:student_profile).find_each do |student|
      if student.respond_to?(:add_role_activity)
        student.add_role_activity('course:show')
      end
    end
  end

  def down
    Person.joins(:student_profile).find_each do |student|
      if student.respond_to?(:remove_role_activity)
        student.remove_role_activity('course:show')
      end
    end
  end
end