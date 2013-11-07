class AkademGroup < ActiveRecord::Base
  has_many  :group_participations, dependent: :destroy
  has_many  :student_profiles, through: :group_participations
end
