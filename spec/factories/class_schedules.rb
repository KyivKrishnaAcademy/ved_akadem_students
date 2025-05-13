FactoryBot.define do
  factory :class_schedule do
    classroom
    course
    finish_time     { Time.zone.now + 2.hours }
    start_time      { Time.zone.now + 1.hour }
  end
end
