require 'rails_helper'

describe PersonClassSchedulesLoadingInteraction do
  Given(:user) { create :person }
  Given(:interaction) { PersonClassSchedulesLoadingInteraction.new(user: user, params: { page: 1 }) }

  describe 'calls ClassSchedule#personal_schedule' do
    Given(:result) { ClassSchedule.none.page(nil).per(1) }

    Then { expect(ClassScheduleWithPeople).to receive(:personal_schedule).with(user, 1).and_return(result) }
    And  { expect(interaction.as_json).to eq({ class_schedules: [], pages: 0 }) }
  end

  shared_examples_for :class_schedules_loadable do
    Given(:group) { create :academic_group, title: group_title }
    Given(:course) { create :course, title: course_title }
    Given(:subject) { 'Шудха Кришна бхакти' }
    Given(:classroom) { create :classroom, title: classroom_title }
    Given(:start_time) { '01.01.2015 12:01' }
    Given(:group_title) { 'ШБ11-9' }
    Given(:finish_time) { '01.01.2015 13:02' }
    Given(:result_time) { 'Чт 01.01.15 12:01 - 13:02' }
    Given(:course_title) { 'Bhakti school' }
    Given(:classroom_title) { 'Antardwipa' }
    Given(:teacher_profile) { create :teacher_profile }

    Given(:full_schedule) { create :class_schedule, course: course, classroom: classroom,
                                                    teacher_profile: teacher_profile,
                                                    subject: subject, start_time: start_time,
                                                    finish_time: finish_time, academic_groups: [group] }

    Given(:optional_schedule) { create :class_schedule, course: course, classroom: classroom,
                                                        start_time: start_time, finish_time: finish_time }

    Given(:group_can_view) { false }
    Given(:course_can_view) { false }
    Given(:lector_can_view) { false }
    Given(:schedule_can_edit) { false }
    Given(:schedule_can_delete) { false }

    Given(:path_helper) { Rails.application.routes.url_helpers }

    Given(:expected_full_payload) do
      {
        class_schedules: [
          { id: full_schedule.id,
            subject: subject,
            course: {
              id: course.id,
              title: course_title,
              can_view: course_can_view,
              path: path_helper.course_path(course)
            },
            lector: {
              id: teacher_profile.person.id,
              path: path_helper.person_path(teacher_profile.person),
              can_view: lector_can_view,
              complex_name: teacher_profile.person.spiritual_name
            },
            academic_groups: [
              {
                id: group.id,
                title: group_title,
                can_view: group_can_view,
                path: path_helper.academic_group_path(group)
              }
            ],
            classroom: classroom_title,
            time: result_time,
            can_edit: schedule_can_edit,
            can_delete: schedule_can_delete,
            edit_path: path_helper.edit_class_schedule_path(full_schedule),
            delete_path: path_helper.class_schedule_path(full_schedule)
          }
        ],
        pages: 1
      }
    end

    Given(:paginated_array) { Kaminari.paginate_array(array_for_pagination).page(1).per(10) }

    Given { allow(ClassScheduleWithPeople).to receive(:personal_schedule).and_return(paginated_array) }

    describe 'optional schedule' do
      Given { allow(optional_schedule).to receive(:real_class_schedule).and_return(optional_schedule) }

      Given(:array_for_pagination) { [optional_schedule] }

      Given(:expected_optional_payload) do
        {
          class_schedules: [
            { id: optional_schedule.id,
              subject: nil,
              course: {
                id: course.id,
                title: course_title,
                can_view: false,
                path: path_helper.course_path(course)
              },
              lector: nil,
              academic_groups: [],
              classroom: classroom_title,
              time: result_time,
              can_edit: false,
              can_delete: false,
              edit_path: path_helper.edit_class_schedule_path(optional_schedule),
              delete_path: path_helper.class_schedule_path(optional_schedule)
            }
          ],
          pages: 1
        }
      end

      Then { expect(interaction.as_json).to eq(expected_optional_payload) }
    end

    describe 'full schedule' do
      Given { allow(full_schedule).to receive(:real_class_schedule).and_return(full_schedule) }

      Given(:user) { create :person, roles: [create(:role, activities: activities)] }
      Given(:activities) { ['some'] }
      Given(:array_for_pagination) { [full_schedule] }

      describe 'no permissions' do
        Then { expect(interaction.as_json).to eq(expected_full_payload) }
      end

      describe 'can view group' do
        Given(:group_can_view) { true }
        Given(:activities) { ['academic_group:show'] }

        Then { expect(interaction.as_json).to eq(expected_full_payload) }
      end

      describe 'can view course' do
        Given(:course_can_view) { true }
        Given(:activities) { ['course:show'] }

        Then { expect(interaction.as_json).to eq(expected_full_payload) }
      end

      describe 'can view course' do
        Given(:lector_can_view) { true }
        Given(:activities) { ['person:show'] }

        Then { expect(interaction.as_json).to eq(expected_full_payload) }
      end

      describe 'can edit schedule' do
        Given(:schedule_can_edit) { true }
        Given(:activities) { ['class_schedule:edit'] }

        Then { expect(interaction.as_json).to eq(expected_full_payload) }
      end

      describe 'can delete schedule' do
        Given(:schedule_can_delete) { true }
        Given(:activities) { ['class_schedule:destroy'] }

        Then { expect(interaction.as_json).to eq(expected_full_payload) }
      end
    end
  end

  it_behaves_like :class_schedules_loadable
end
