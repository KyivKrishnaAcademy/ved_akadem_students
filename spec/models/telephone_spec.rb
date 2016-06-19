require 'rails_helper'

describe Telephone do
  describe 'association' do
    Then { is_expected.to belong_to(:person) }
  end

  describe 'validation' do
    context 'phone' do
      Then { is_expected.not_to allow_value('').for(:phone) }
      And  { is_expected.not_to allow_value('123').for(:phone) }
      And  { is_expected.not_to allow_value('+1063331122').for(:phone) }

      And  { is_expected.to allow_value('063 333 11 22').for(:phone) }
      And  { is_expected.to allow_value('+380 63 333 11 22').for(:phone) }
      And  { is_expected.to allow_value('+7 495 739-22-22').for(:phone) }
    end
  end

  describe 'normalize phone before validation' do
    Given(:telephone) { create :telephone, phone: phone }

    When { telephone.valid? }

    context '063 333 11 22' do
      Given(:phone) { '063 333 11 22' }

      Then { expect(telephone.phone).to eq('+380633331122') }
    end

    context '+380 63 333 11 22' do
      Given(:phone) { '+380 63 333 11 22' }

      Then { expect(telephone.phone).to eq('+380633331122') }
    end

    context '+7 495 739-22-22' do
      Given(:phone) { '+7 495 739-22-22' }

      Then { expect(telephone.phone).to eq('+74957392222') }
    end
  end
end
