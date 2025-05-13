describe AnswersProcessorService do
  Given(:person) { create :person }
  Given(:questionnaire) { create :questionnaire, :psycho_test }

  subject { described_class.new(questionnaire, person) }

  describe '#process!' do
    Given!(:completeness) { QuestionnaireCompleteness.create(person: person, questionnaire: questionnaire) }

    Given do
      questionnaire.questions.each do |question|
        Answer.create(person: person, question: question, data: 1)
      end
    end

    When  { subject.process! }
    When  { completeness.reload }

    Then  { expect(completeness.completed?).to be(true) }

    And do
      actual = (1..10).map do |k|
        r = completeness.result[k.to_s] || completeness.result[k] || {}
        [r['max'], r['color'], r['current'], r['percentage']]
      end

      expect(actual).to eq(
        [
          [22, 'info',    11, 50],
          [8,  'danger',  8,  100],
          [26, 'danger',  26, 100],
          [20, 'danger',  20, 100],
          [18, 'info',    9,  50],
          [11, 'danger',  11, 100],
          [13, 'danger',  13, 100],
          [11, 'danger',  11, 100],
          [18, 'danger',  15, 83],
          [12, 'danger',  12, 100]
        ]
      )
    end
  end
end
