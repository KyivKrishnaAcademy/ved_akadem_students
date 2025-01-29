FactoryBot.define do
  factory :certificate do
    academic_group
    certificate_template
    student_profile
    serial_id { "#{academic_group.title}-#{certificate_template.id}-#{student_profile.person_id}" }
    issued_date { Time.zone.today }
  end
end
