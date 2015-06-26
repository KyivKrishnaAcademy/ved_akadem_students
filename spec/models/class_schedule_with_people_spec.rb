require 'rails_helper'

describe ClassScheduleWithPeople do
  When { ClassScheduleWithPeople.refresh }

  describe 'readonly' do
    Given { create :class_schedule }

    Given(:instance) { ClassScheduleWithPeople.first }

    Then { expect{ClassScheduleWithPeople.create}.to raise_error(ActiveRecord::ReadOnlyRecord) }
    Then { expect{instance.save}.to raise_error(ActiveRecord::ReadOnlyRecord) }
    Then { expect{instance.update_attributes(subject: 'other text')}.to raise_error(ActiveRecord::ReadOnlyRecord) }
    Then { expect{instance.update_attribute(:subject, 'other text')}.to raise_error(ActiveRecord::ActiveRecordError) }
    Then { expect{instance.update_column(:subject, 'other text')}.to raise_error(ActiveRecord::ActiveRecordError) }
    Then { expect{instance.delete}.to raise_error(ActiveRecord::ReadOnlyRecord) }
    Then { expect{instance.destroy}.to raise_error(ActiveRecord::ReadOnlyRecord) }
  end

  describe 'methods' do
    describe '#real_class_schedule' do
      Given!(:class_schedule) { create :class_schedule }

      Then { expect(ClassScheduleWithPeople.find(class_schedule.id).real_class_schedule).to eq(class_schedule) }
    end
  end
end
