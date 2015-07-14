# coding: utf-8


require 'rails_helper'

describe Attachment do
  let(:file) { File.open Rails.root.join('spec/fixtures/2345.jpg'), 'rb'}

  describe '.width .height' do
    before do
      CarrierWave.configure do |config|
        config.enable_processing = true
      end
    end

    after do
      CarrierWave.configure do |config|
        config.enable_processing = false
      end
    end
    subject { Attachment.create file: file }
    its(:width) { should_not be_blank }
    its(:height) { should_not be_blank }
  end
end
