class GroupParticipation < ActiveRecord::Base
  belongs_to  :student_profile
  belongs_to  :akadem_group
end
