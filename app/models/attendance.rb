class Attendance < ActiveRecord::Base
  belongs_to  :class_schedule
  belongs_to  :student_profile
end
