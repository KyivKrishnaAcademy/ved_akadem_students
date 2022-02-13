require 'rails_helper'

describe Person do
  describe 'fields' do
    Then { is_expected.to have_db_column(:education).of_type(:text) }
    Then { is_expected.to have_db_column(:work).of_type(:text) }
    Then { is_expected.not_to have_db_column(:edu_and_work) }
  end

  describe 'association' do
    Then { is_expected.to have_one(:student_profile).dependent(:destroy) }
    Then { is_expected.to have_one(:teacher_profile).dependent(:destroy) }
    Then { is_expected.to have_one(:study_application).dependent(:destroy) }
    Then { is_expected.to have_and_belong_to_many(:roles) }
    Then { is_expected.to have_many(:telephones).dependent(:destroy) }
    Then { is_expected.to have_many(:notes).dependent(:destroy) }
    Then { is_expected.to have_many(:answers).dependent(:destroy) }
    Then { is_expected.to have_many(:questionnaire_completenesses).dependent(:destroy) }
    Then { is_expected.to have_many(:questionnaires).through(:questionnaire_completenesses) }
  end

  describe 'validation' do
    context 'privacy_agreement' do
      Then { is_expected.to validate_acceptance_of(:privacy_agreement).on(:create) }
    end

    describe 'should skip privacy_agreement validation' do
      Then { expect(build(:person, privacy_agreement: '', skip_password_validation: true)).to be_valid }
    end

    context 'password' do
      Then { is_expected.to validate_length_of(:password).is_at_most(128) }
      And  { is_expected.to validate_length_of(:password).is_at_least(6) }
      And  do
        # due to https://github.com/thoughtbot/shoulda-matchers/issues/593
        # This do not work "is_expected.to validate_confirmation_of(:password)"

        error_message = I18n.t('activerecord.errors.models.person.attributes.password_confirmation.confirmation')
        person        = subject.dup

        person.password               = 'value'
        person.password_confirmation  = 'different value'
        person.save

        expect(person.errors.messages[:password_confirmation].first).to eq(error_message)
      end
    end

    describe 'should skip password validation' do
      Then do
        expect(build(:person, password: '', password_confirmation: '', skip_password_validation: true)).to be_valid
      end
    end

    context 'gender' do
      Then { is_expected.to allow_value(true, false).for(:gender) }
      And  { is_expected.not_to allow_value(nil).for(:gender) }
    end

    context 'email' do
      subject { build(:person, uid: 'ololo') }

      Given(:valid_addresses)   { %w(user@foo.COM A_US-ER@f.b.org frst.lst@foo.jp a+b@baz.cn) }
      Given(:invalid_addresses) { %w(user@foo,com user_at_foo.org example.user@foo.foo@bar_baz.com foo@bar+baz.com) }

      Then { is_expected.to validate_uniqueness_of(:email).case_insensitive }
      And { is_expected.not_to allow_value('').for(:email) }
      And do
        invalid_addresses.each do |invalid_address|
          is_expected.not_to allow_value(invalid_address).for(:email)
        end
      end
      And do
        valid_addresses.each do |valid_address|
          is_expected.to allow_value(valid_address).for(:email)
        end
      end
    end

    context 'marital_status' do
      Then { is_expected.to validate_presence_of(:marital_status) }
    end

    context 'name, surname, middle_name' do
      Then { is_expected.to validate_presence_of(:name) }
      And  { is_expected.to validate_length_of(:name).is_at_most(50) }

      Then { is_expected.to validate_presence_of(:surname) }
      And  { is_expected.to validate_length_of(:surname).is_at_most(50) }

      Then { is_expected.to validate_length_of(:middle_name).is_at_most(50) }
    end

    describe 'photo' do
      context 'less then 150x200 not valid' do
        Then { expect(build(:person, photo: Rails.root.join('spec/fixtures/10x10.png').open)).not_to be_valid }
      end

      context 'equals 150x200 valid' do
        Then { expect(build(:person, :with_photo)).to be_valid }
      end
    end

    describe 'birthday' do
      Then { is_expected.to validate_presence_of(:birthday) }
    end
  end

  describe 'before save processing' do
    context 'downcases :email' do
      Then { expect(create(:person, email: 'A_US-ER@f.B.org').email).to eq('a_us-er@f.b.org') }
    end

    context 'sets complex_name' do
      Given(:subject) { create(:person, params).complex_name }
      Given(:generic_params) do
        { diploma_name: 'Adi das', name: 'Vasya', surname: 'Pupkin', middle_name: 'Petrovich' }
      end

      context 'diploma_name is present' do
        context 'with middle_name' do
          Given(:params) { generic_params }

          Then { is_expected.to eq('Adi das (Pupkin Vasya Petrovich)') }
        end

        context 'without middle_name' do
          Given(:params) { generic_params.merge(middle_name: nil) }

          Then { is_expected.to eq('Adi das (Pupkin Vasya)') }
        end
      end

      context 'diploma_name is blank' do
        context 'with middle_name' do
          Given(:params) { generic_params.merge(diploma_name: nil) }

          Then { is_expected.to eq('Pupkin Vasya Petrovich') }
        end

        context 'without middle_name' do
          Given(:params) { generic_params.merge(diploma_name: nil, middle_name: nil) }

          Then { is_expected.to eq('Pupkin Vasya') }
        end
      end
    end
  end

  describe 'methods' do
    Given(:person) do
      create :person, diploma_name: 'Adi das', surname: 'Zlenkno', middle_name: 'Zakovich', name: 'Zinoviy'
    end

    describe '#crop_photo' do
      Given { person.update(photo: Rails.root.join('spec/fixtures/150x200.png').open) }

      Then { expect(person.photo).to receive(:recreate_versions!) }
      And  { expect(person.crop_photo(crop_x: 0, crop_y: 1, crop_h: 2, crop_w: 3)).to be(true) }
      And  { expect(person.crop_x).to eq(0) }
      And  { expect(person.crop_y).to eq(1) }
      And  { expect(person.crop_h).to eq(2) }
      And  { expect(person.crop_w).to eq(3) }
    end

    describe 'questionnaires methods' do
      Given(:program) { create :program, questionnaires: [questionnaire_1] }
      Given(:questionnaire_1) { create :questionnaire }
      Given(:questionnaire_2) { create :questionnaire }
      Given(:study_application) { StudyApplication.create(person_id: person.id, program_id: program.id) }

      describe '#add_application_questionnaires' do
        Given { study_application }

        Then  { expect { person.add_application_questionnaires }.to change { person.questionnaires.count }.by(1) }
        And   { expect(person.reload.questionnaire_ids).to eq([questionnaire_1.id]) }
        And   { expect { person.add_application_questionnaires }.not_to change { person.questionnaires.count } }
      end

      describe '#remove_application_questionnaires' do
        context 'not completed' do
          Given { person.questionnaires << [questionnaire_1, questionnaire_2] }

          Then do
            expect { person.remove_application_questionnaires(study_application) }
              .to change { person.questionnaires.count }.by(-1)
          end
        end

        context 'completed' do
          Given do
            QuestionnaireCompleteness.create(
              person_id: person.id,
              questionnaire_id: questionnaire_1.id,
              completed: true
            )
          end

          Then do
            expect { person.remove_application_questionnaires(study_application) }
              .not_to change { person.questionnaires.count }
          end
        end
      end

      describe '#not_finished_questionnaires' do
        Given(:person_2) { create :person }

        Given { person.questionnaire_completenesses.create(completed: true,  questionnaire_id: questionnaire_1.id) }
        Given { person.questionnaire_completenesses.create(completed: false, questionnaire_id: questionnaire_2.id) }
        Given { person_2.questionnaire_completenesses.create(questionnaire_id: questionnaire_1.id) }
        Given { person_2.questionnaire_completenesses.create(questionnaire_id: questionnaire_2.id) }

        Then  { expect(person.not_finished_questionnaires.map(&:id)).to eq([questionnaire_2.id]) }
      end

      describe '#can_act?' do
        Given { create :role, activities: %w(some:activity), people: [person] }

        Then  { expect(person.can_act?('some:activity')).to be(true) }
        And   { expect(person.can_act?(['some:activity'])).to be(true) }
        And   { expect(person.can_act?(['other:activity', 'some:activity'])).to be(true) }
        And   { expect(person.can_act?('other:activity')).to be(false) }
      end

      describe '#psycho_test_result' do
        context 'no psycho test' do
          Then { expect(person.psycho_test_result).to be_nil }
        end

        context 'with result' do
          Given(:psycho_test) { create :questionnaire, kind: 'psycho_test' }

          Given { person.questionnaire_completenesses.create(questionnaire_id: psycho_test.id, result: { a: :b }) }

          Then  { expect(person.psycho_test_result).to eq(a: :b) }
        end
      end
    end

    describe '#last_academic_group' do
      Given(:sp) { person.create_student_profile }
      Given(:ag_1) { create :academic_group }
      Given(:ag_2) { create :academic_group }

      Given do
        GroupParticipation.create(
          student_profile: sp,
          academic_group: ag_1,
          join_date: DateTime.current.yesterday,
          leave_date: DateTime.current
        )
      end

      Given { GroupParticipation.create(student_profile: sp, academic_group: ag_2, join_date: DateTime.current) }

      Then  { expect(person.last_academic_groups.first.title).to eq(ag_2.title) }
    end

    describe '#by_complex_name' do
      Given(:person_2) do
        create :person, diploma_name: nil, surname: 'Aavramenko', middle_name: 'Zakovich', name: 'Zinoviy'
      end

      Given(:person_3) do
        create :person, diploma_name: nil, surname: 'Babenko', middle_name: 'Borisovich', name: 'Artem'
      end

      Given(:person_4) do
        create :person, diploma_name: nil, surname: 'Babenko', middle_name: 'Andreevich', name: 'Artem'
      end

      Then { expect(Person.by_complex_name).to eq([person_2, person, person_4, person_3]) }
    end

    context 'study application scopes' do
      Given(:program_1) { create :program, manager: person }
      Given(:program_2) { create :program, manager: person }

      Given(:person_1) { create :person }
      Given(:person_2) { create :person }

      Given { person_1.create_study_application(program: program_1) }
      Given { person_2.create_study_application(program: program_2) }

      describe '#with_application' do
        Then { expect(Person.with_application(program_1.id)).to eq([person_1]) }
      end

      describe '#without_application' do
        Given!(:student) { create(:person).create_student_profile }
        Given!(:teacher) { create(:person).create_teacher_profile }

        Then { expect(Person.without_application).to eq([person]) }
      end
    end

    describe '#pending_docs' do
      context 'no photo, has no questionnaires' do
        Then  { expect(person.pending_docs).to eq(photo: :photo) }
      end

      context 'has photo' do
        Given { allow(person).to receive_message_chain(:photo, :blank?).and_return(false) }

        Then  { expect(person.pending_docs).to eq({}) }
      end

      context 'has completed questionnaire' do
        Given do
          person.questionnaire_completenesses.create(completed: true, questionnaire_id: create(:questionnaire).id)
        end

        Then  { expect(person.pending_docs).to eq(photo: :photo) }
      end

      context 'has has two unanswered questionnaires' do
        Given { person.questionnaires << [create(:questionnaire), create(:questionnaire)] }

        Then  { expect(person.pending_docs).to eq(questionnaires: 2, photo: :photo) }
      end
    end

    describe 'delegated #student_active?' do
      Then { expect(person.student_active?).to be_nil }

      Then { is_expected.to delegate_method(:active?).to(:student_profile).with_prefix(:student) }
    end

    describe '#short_name' do
      context 'diploma_name present' do
        Then { expect(person.short_name).to eq 'Adi das' }
      end

      context 'no diploma_name' do
        context 'middle_name present' do
          Given { person.update(diploma_name: '') }

          Then { expect(person.short_name).to eq 'Zlenkno Zinoviy' }
        end
      end
    end

    describe '#respectful_name' do
      context 'diploma_name present' do
        Then { expect(person.respectful_name).to eq 'Adi das' }
      end

      context 'no diploma_name' do
        context 'middle_name present' do
          Given { person.update(diploma_name: '') }

          Then { expect(person.respectful_name).to eq 'Zinoviy Zakovich' }
        end

        context 'no middle_name' do
          Given { person.update(diploma_name: '', middle_name: '') }

          Then { expect(person.respectful_name).to eq 'Zinoviy' }
        end
      end
    end
  end
end
