# coding: utf-8
# Based on
# https://github.com/ng/paperclip-watermarking-app/blob/master/lib/paperclip_processors/watermark.rb
# Modified by Laurynas Butkus
require File.join(File.dirname(__FILE__), 'watermark')
module Paperclip
  class GifWatermark < Watermark
    def make
      return file unless orig = attachment.queued_for_write[:original]
      result = `identify "#{orig.path}"`
      result.scan(/\n/).size > 1 ? super : file
    end
  end
end

