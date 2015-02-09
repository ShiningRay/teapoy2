class << File
  alias orig_rename rename
  def rename(src, dest)
    Rails.logger.debug(src.inspect)
    Rails.logger.debug(src.encoding.inspect)
    Rails.logger.debug(dest.inspect)
    Rails.logger.debug(dest.encoding.inspect)
    src = src.to_path if src.respond_to? :to_path
    dest = dest.to_path if dest.respond_to? :to_path
    src = src.dup.force_encoding 'BINARY' if src.encoding == Encoding::UTF_8
    dest = dest.dup.force_encoding 'BINARY' if dest.encoding == Encoding::UTF_8
    orig_rename(src, dest)
  end
end

