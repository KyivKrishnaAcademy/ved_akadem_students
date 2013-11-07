class Person < ActiveRecord::Base
  has_one :student_profile, dependent: :destroy
end
