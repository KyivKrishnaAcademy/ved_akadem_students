require 'rails_helper'

describe PersonDecorator do
  subject { PersonDecorator.new(@person) }
  Given   { @person = create :person }

  describe '#pending_docs' do
    context 'no photo or passport, has no questionnaires' do
      Then  { expect(subject.pending_docs).to eq({photo: :photo, passport: :passport}) }
    end

    context 'has passport' do
      Given { allow(@person).to receive_message_chain(:passport, :blank?).and_return(false) }

      Then  { expect(subject.pending_docs).to eq({photo: :photo}) }
    end

    context 'has photo' do
      Given { allow(@person).to receive_message_chain(:photo, :blank?).and_return(false) }

      Then  { expect(subject.pending_docs).to eq({passport: :passport}) }
    end

    context 'has completed questionnaire' do
      Given { @person.questionnaire_completenesses.create(completed: true, questionnaire_id: create(:questionnaire).id) }

      Then  { expect(subject.pending_docs).to eq({photo: :photo, passport: :passport}) }
    end

    context 'has has two unanswered questionnaires' do
      Given { @person.questionnaires << [create(:questionnaire), create(:questionnaire)] }

      Then  { expect(subject.pending_docs).to eq({questionnaires: 2, photo: :photo, passport: :passport}) }
    end
  end
end
