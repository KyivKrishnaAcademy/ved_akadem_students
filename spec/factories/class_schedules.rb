FactoryGirl.define do
  factory :class_schedule do
    academic_groups { [build(:academic_group)] }
    classroom
    course
    finish_time     { Time.now + 2.hour }
    start_time      { Time.now + 1.hour }
    teacher_profile
  end
end
