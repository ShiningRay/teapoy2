Paperclip.interpolates('oid') do |attachment, style|
  attachment.instance.id.to_s.sub(/^0+/, '')
end