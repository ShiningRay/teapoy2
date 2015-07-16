# coding: utf-8
# == Schema Information
#
# Table name: attachments
#
#  id           :integer          not null, primary key
#  uploader_id  :integer          default(0), not null
#  post_id      :integer          not null
#  file         :string(255)
#  content_type :string(20)
#  file_size    :integer
#  width        :integer          default(0), not null
#  height       :integer          default(0), not null
#  original_url :string(255)
#  checksum     :string(32)
#
# Indexes
#
#  index_attachments_on_post_id      (post_id)
#  index_attachments_on_uploader_id  (uploader_id)
#



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
