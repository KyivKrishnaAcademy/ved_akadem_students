require 'spec_helper'

describe PersonDecorator do
  subject { PersonDecorator.new(@person) }
  Given   { @person = create :person }

  describe '#pending_docs' do
    context 'no photo or passport, has no questionnaires' do
      Then  { subject.pending_docs.should == {photo: :photo, passport: :passport} }
    end

    context 'has passport' do
      Given { @person.stub_chain(:passport, :blank?).and_return(false) }

      Then  { subject.pending_docs.should == {photo: :photo} }
    end

    context 'has photo' do
      Given { @person.stub_chain(:photo, :blank?).and_return(false) }

      Then  { subject.pending_docs.should == {passport: :passport} }
    end

    context 'has completed questionnaire' do
      Given { @person.questionnaire_completenesses.create(completed: true, questionnaire_id: create(:questionnaire).id) }

      Then  { subject.pending_docs.should == {photo: :photo, passport: :passport} }
    end

    context 'has has two unanswered questionnaires' do
      Given { @person.questionnaires << [create(:questionnaire), create(:questionnaire)] }

      Then  { subject.pending_docs.should == {questionnaires: 2, photo: :photo, passport: :passport} }
    end
  end
end
