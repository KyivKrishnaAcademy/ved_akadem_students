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
      Then { expect(build(:person, password: '', password_confirmation: '', skip_password_validation: true)).to be_valid }
    end

    context 'gender' do
      Then { is_expected.to allow_value(true, false).for(:gender) }
      And  { is_expected.not_to allow_value(nil).for(:gender) }
    end

    context 'email' do
      Given (:valid_addresses)   { %w(user@foo.COM A_US-ER@f.b.org frst.lst@foo.jp a+b@baz.cn) }
      Given (:invalid_addresses) { %w(user@foo,com user_at_foo.org example.user@foo.foo@bar_baz.com foo@bar+baz.com) }

      Then { is_expected.to validate_uniqueness_of(:email) }
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

    context 'name, surname, middle_name, spiritual_name' do
      Then { is_expected.to validate_presence_of(:name) }
      And  { is_expected.to validate_length_of(:name).is_at_most(50) }

      Then { is_expected.to validate_presence_of(:surname) }
      And  { is_expected.to validate_length_of(:surname).is_at_most(50) }

      Then { is_expected.to validate_length_of(:middle_name   ).is_at_most(50) }
      Then { is_expected.to validate_length_of(:spiritual_name).is_at_most(50) }
    end

    describe 'photo' do
      context 'less then 150x200 not valid' do
        Then { expect(build(:person, photo: Rails.root.join('spec/fixtures/10x10.png').open)).not_to be_valid }
      end

      context 'equals 150x200 valid' do
        Then { expect(build(:person, :with_photo)).to be_valid }
      end
    end

    describe 'birthday, education, work' do
      Then { is_expected.to validate_presence_of(:education) }
      And  { is_expected.to validate_presence_of(:birthday) }
      And  { is_expected.to validate_presence_of(:work) }
    end
  end

  describe 'before save processing' do
    context 'downcases :email' do
      Then { expect(create(:person, {email: 'A_US-ER@f.B.org'}).email).to eq('a_us-er@f.b.org') }
    end
  end

  describe 'methods' do
    Given(:person) { create :person, spiritual_name: 'Adi das', surname: 'Zlenkno', middle_name: 'Zakovich', name: 'Zinoviy' }

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

        Then  { expect{person.add_application_questionnaires}.to change{person.questionnaires.count}.by(1) }
        And   { expect(person.questionnaire_ids).to eq([questionnaire_1.id]) }
        And   { expect{person.add_application_questionnaires}.not_to change{person.questionnaires.count} }
      end

      describe '#remove_application_questionnaires' do
        context 'not completed' do
          Given { person.questionnaires << [questionnaire_1, questionnaire_2] }

          Then  { expect{person.remove_application_questionnaires(study_application)}.to change{person.questionnaires.count}.by(-1) }
        end

        context 'completed' do
          Given { QuestionnaireCompleteness.create(person_id: person.id, questionnaire_id: questionnaire_1.id, completed: true) }

          Then  { expect{person.remove_application_questionnaires(study_application)}.not_to change{person.questionnaires.count} }
        end
      end

      describe '#not_finished_questionnaires' do
        Given(:person_2) { create :person }

        Given { person.questionnaire_completenesses.create(completed: true , questionnaire_id: questionnaire_1.id) }
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

          Given { person.questionnaire_completenesses.create(questionnaire_id: psycho_test.id, result: {a: :b}) }

          Then  { expect(person.psycho_test_result).to eq({a: :b}) }
        end
      end
    end

    describe '#last_academic_group' do
      Given(:sp) { person.create_student_profile }
      Given(:ag_1) { create :academic_group }
      Given(:ag_2) { create :academic_group }

      Given { GroupParticipation.create(student_profile: sp, academic_group: ag_1, join_date: DateTime.current.yesterday,
                                        leave_date: DateTime.current) }
      Given { GroupParticipation.create(student_profile: sp, academic_group: ag_2, join_date: DateTime.current) }

      Then  { expect(person.last_academic_group.title).to eq(ag_2.title) }
    end

    describe '#by_complex_name' do
      Given(:person_2) { create :person, spiritual_name: nil, surname: 'Aavramenko', middle_name: 'Zakovich', name: 'Zinoviy'}
      Given(:person_3) { create :person, spiritual_name: nil, surname: 'Babenko', middle_name: 'Borisovich', name: 'Artem'}
      Given(:person_4) { create :person, spiritual_name: nil, surname: 'Babenko', middle_name: 'Andreevich', name: 'Artem'}

      Then  { expect(Person.by_complex_name).to eq([person_2, person, person_4, person_3]) }
    end

    describe '#initial_answers' do
      Given(:person_2) { create :person }
      Given(:question_1) { create :question, :freeform, position: 2 }
      Given(:question_2) { create :question, :freeform, position: 1 }
      Given(:question_3) { create :question, :single_select, position: 1 }
      Given(:questionnaire_1) { create :questionnaire, kind: 'initial_questions', questions: [question_1, question_2] }
      Given(:questionnaire_2) { create :questionnaire, kind: 'psycho_test', questions: [question_3] }

      Given { person.questionnaire_completenesses.create(completed: true, questionnaire_id: questionnaire_1.id) }
      Given { person.questionnaire_completenesses.create(completed: true, questionnaire_id: questionnaire_2.id) }
      Given { person_2.questionnaire_completenesses.create(completed: false, questionnaire_id: questionnaire_1.id) }
      Given { person_2.questionnaire_completenesses.create(completed: false, questionnaire_id: questionnaire_2.id) }

      Given!(:answer_1_1) { create :answer, :freeform_answer, person: person, question: question_1 }
      Given!(:answer_1_2) { create :answer, :freeform_answer, person: person, question: question_2 }
      Given!(:answer_1_3) { create :answer, :single_select_answer, person: person, question: question_3 }
      Given!(:answer_2_1) { create :answer, :freeform_answer, person: person_2, question: question_1 }
      Given!(:answer_2_2) { create :answer, :freeform_answer, person: person_2, question: question_2 }
      Given!(:answer_2_3) { create :answer, :single_select_answer, person: person_2, question: question_3 }

      Then  { expect(person.initial_answers).to eq([answer_1_2, answer_1_1]) }
      And   { expect(person_2.initial_answers).to be_empty }
    end

    describe '#pending_docs' do
      context 'no photo or passport, has no questionnaires' do
        Then  { expect(person.pending_docs).to eq({photo: :photo, passport: :passport}) }
      end

      context 'has passport' do
        Given { allow(person).to receive_message_chain(:passport, :blank?).and_return(false) }

        Then  { expect(person.pending_docs).to eq({photo: :photo}) }
      end

      context 'has photo' do
        Given { allow(person).to receive_message_chain(:photo, :blank?).and_return(false) }

        Then  { expect(person.pending_docs).to eq({passport: :passport}) }
      end

      context 'has completed questionnaire' do
        Given { person.questionnaire_completenesses.create(completed: true, questionnaire_id: create(:questionnaire).id) }

        Then  { expect(person.pending_docs).to eq({photo: :photo, passport: :passport}) }
      end

      context 'has has two unanswered questionnaires' do
        Given { person.questionnaires << [create(:questionnaire), create(:questionnaire)] }

        Then  { expect(person.pending_docs).to eq({questionnaires: 2, photo: :photo, passport: :passport}) }
      end
    end
  end
end
