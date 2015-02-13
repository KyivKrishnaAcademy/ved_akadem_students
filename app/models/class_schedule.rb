class ClassSchedule < ActiveRecord::Base
  belongs_to :teacher_profile
  belongs_to :classroom
  belongs_to :academic_group
  belongs_to :course
  has_many :attendances, dependent: :destroy
end
