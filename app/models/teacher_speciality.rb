class TeacherSpeciality < ActiveRecord::Base
  belongs_to  :course
  belongs_to  :teacher_profile
end
