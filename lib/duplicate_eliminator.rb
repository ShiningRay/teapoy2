# coding: utf-8
require 'digest/md5'
# TODO: use set of redis to store the content hash and check the potential
# *race condition*

class DuplicateEliminator < ActiveModel::Validator
  MAX_HASHES_COUNT = 50
  def validate(record)
    recent_content_hash = Array.wrap(Rails.cache.read('recent_content_hash'))
    Rails.logger.debug{"Recent Hash: #{recent_content_hash.join(',')}"}
    Array.wrap(options[:fields]).each do |field|
      content = record.send(field)
      h = self.class.hash_method(content)
      Rails.logger.debug{"This hash: #{h}"}
      if recent_content_hash.include?(h)
        record.errors[:base] << 'Please do not post duplicate content'
      else
        #recent_content_hash << h
        #recent_content_hash if recent_content_hash.size > MAX_HASHES_COUNT
        Rails.cache.write('recent_content_hash', recent_content_hash + [h], :expires_in => 10.minutes)
      end
    end
  end
  def self.hash_method(content)
    Digest::MD5.hexdigest(content)
  end
end
