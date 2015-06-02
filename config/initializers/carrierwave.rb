if Rails.env.production?
CarrierWave.configure do |config|
  config.storage             = :qiniu
  config.qiniu_access_key    = "2KXKlRHy6rXR9jNKN3JKoC4w9H9MZtV7K8KtPJir"
  config.qiniu_secret_key    = 'P7rVeqLvZPS2fdXAltfrUSpOsajzLmCfaQy15GSR'
  config.qiniu_bucket        = "bling"
  config.qiniu_bucket_domain = "7xjf3t.com1.z0.glb.clouddn.com"
  config.qiniu_bucket_private= true #default is false
  config.qiniu_block_size    = 4*1024*1024
  config.qiniu_protocol      = "http"

  # config.qiniu_up_host       = 'http://up.qiniug.com' #七牛上传海外服务器,国内使用可以不要这行配置
end
else
  CarrierWave.configure do |config|
    config.storage             = :qiniu
    config.qiniu_access_key    = "2KXKlRHy6rXR9jNKN3JKoC4w9H9MZtV7K8KtPJir"
    config.qiniu_secret_key    = 'P7rVeqLvZPS2fdXAltfrUSpOsajzLmCfaQy15GSR'
    config.qiniu_bucket        = "bling-test"
    config.qiniu_bucket_domain = "7xjg2e.com1.z0.glb.clouddn.com"
    config.qiniu_bucket_private= true #default is false
    config.qiniu_block_size    = 4*1024*1024
    config.qiniu_protocol      = "http"

    # config.qiniu_up_host       = 'http://up.qiniug.com' #七牛上传海外服务器,国内使用可以不要这行配置
  end
end
