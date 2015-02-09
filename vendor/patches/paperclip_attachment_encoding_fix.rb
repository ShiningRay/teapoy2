class Paperclip::Attachment
  def original_filename
    n = instance_read(:file_name)
    n.is_a?(String) ? n.force_encoding('binary') : n
  end
end

