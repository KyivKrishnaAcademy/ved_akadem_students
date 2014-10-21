require 'rails_helper'
require 'carrierwave/test/matchers'

describe PhotoUploader do
  include CarrierWave::Test::Matchers

  before do
    PhotoUploader.enable_processing = true
    @uploader = PhotoUploader.new(create(:person), :photo)
    @uploader.store!(File.open(Rails.root.join('spec/fixtures/800x600.png')))
  end

  after do
    PhotoUploader.enable_processing = false
    @uploader.remove!
  end

  context 'the thumb version' do
    Then { expect(@uploader.thumb).to have_dimensions(24, 32) }
  end

  context 'the small version' do
    Then { expect(@uploader.standart).to have_dimensions(150, 200) }
  end

  context 'base version' do
    Then { expect(@uploader).to be_no_larger_than(500, 500) }
  end
end
