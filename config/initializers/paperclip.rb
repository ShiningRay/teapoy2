if Rails.env.production?
  Paperclip::Attachment.default_options[:storage] = :qiniu
  Paperclip::Attachment.default_options[:qiniu_credentials] = {
    :access_key => '2KXKlRHy6rXR9jNKN3JKoC4w9H9MZtV7K8KtPJir',
    :secret_key => 'P7rVeqLvZPS2fdXAltfrUSpOsajzLmCfaQy15GSR'
  }
  Paperclip::Attachment.default_options[:bucket] = 'bling'
  Paperclip::Attachment.default_options[:use_timestamp] = false
  Paperclip::Attachment.default_options[:qiniu_host] =
    'http://7xjf3t.com1.z0.glb.clouddn.com'
end
