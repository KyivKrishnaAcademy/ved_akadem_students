FactoryGirl.define do
  factory :class_schedule do
    classroom
    course
    finish_time     { Time.now + 2.hour }
    start_time      { Time.now + 1.hour }
  end
end
