include HelperMethods

FactoryGirl.create(:person, :admin)

2.times { FactoryGirl.create(:academic_group_schedule) }

AcademicGroup.all.each { |g| 4.times { FactoryGirl.create(:group_participation, academic_group: g) } }

init_schedules_mv

Rake::Task['academic:create_programs'].invoke
Rake::Task['academic:create_questionnaires'].invoke

Program.ids.each { |p_id| 2.times { StudyApplication.create(program_id: p_id, person: FactoryGirl.create(:person)) } }
