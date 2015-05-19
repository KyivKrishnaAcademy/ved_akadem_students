FactoryGirl.define do
  factory :class_schedule do
    academic_groups { [build(:academic_group)] }
    classroom
    course
    teacher_profile
  end
end
