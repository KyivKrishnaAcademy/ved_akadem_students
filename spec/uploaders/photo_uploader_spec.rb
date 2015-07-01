require 'rails_helper'
require 'carrierwave/test/matchers'

if ENV['TRAVIS_off'].blank?
  describe PhotoUploader do
    include CarrierWave::Test::Matchers

    before { PhotoUploader.enable_processing = true }

    after { PhotoUploader.enable_processing = false }

    let(:person) { create(:person, photo: Rails.root.join('spec/fixtures/800x600.png').open) }

    context 'the thumb version' do
      Then { expect(person.photo.thumb).to have_dimensions(24, 32) }
    end

    context 'the standart version' do
      Then { expect(person.photo.standart).to have_dimensions(150, 200) }
    end

    context 'manual crop' do
      When { person.crop_photo(crop_x: 0, crop_y: 0, crop_w: 210, crop_h: 280) }

      Then { expect(person.photo.standart).to have_dimensions(150, 200) }
      And  { expect(person.photo.thumb).to have_dimensions(24, 32) }
    end

    context 'base version' do
      Then { expect(person.photo).to be_no_larger_than(500, 500) }
    end
  end
end
