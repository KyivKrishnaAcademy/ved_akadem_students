# require 'rails_helper'
require 'pundit/rspec'

describe AcademicGroupPolicy do
  subject { AcademicGroupPolicy }

  Given(:record) { create(:academic_group) }
  Given(:user)   { create(:person) }

  shared_examples_for 'user is student of other group' do
    Given { user.create_student_profile.move_to_group(create(:academic_group)) }

    Then  { is_expected.not_to permit(user, record) }
  end

  shared_examples_for 'user is student of the group' do
    Given { user.create_student_profile.move_to_group(record) }

    Then  { is_expected.to permit(user, record) }
  end

  shared_examples_for 'user is curator of the group' do
    Given { record.update(curator: user) }

    Then  { is_expected.to permit(user, record) }
  end

  shared_examples_for 'user is administrator of the group' do
    Given { record.update(administrator: user) }

    Then  { is_expected.to permit(user, record) }
  end

  context 'complex conditions' do
    permissions :show? do
      it_behaves_like 'user is student of the group'
      it_behaves_like 'user is curator of the group'
      it_behaves_like 'user is administrator of the group'
      it_behaves_like 'user is student of other group'

      it_behaves_like :allow_with_activities, ['academic_group:show']
    end

    %i(group_list attendance_template).each do |described_permission|
      permissions :"#{described_permission}_pdf?" do
        describe "with 'academic_group:#{described_permission}_pdf'" do
          Given { user.roles << [create(:role, activities: ["academic_group:#{described_permission}_pdf"])] }

          it_behaves_like 'user is student of the group'
          it_behaves_like 'user is curator of the group'
          it_behaves_like 'user is administrator of the group'
          it_behaves_like 'user is student of other group'
        end

        it_behaves_like :allow_with_activities, ["academic_group:#{described_permission}_pdf", 'academic_group:show']
      end
    end

    it_behaves_like :class_schedule_ui_index
  end
end
