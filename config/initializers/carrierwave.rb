CarrierWave.configure do |config|
  # config.storage = :file
  # config.asset_host = ActionController::Base.asset_host
  config.storage = :qiniu
  if Rails.application.secrets.qiniu.blank?
    raise 'Please configure qiniu settings in secrets.yml'
  else
    Rails.application.secrets.qiniu.each_pair do |key, val|
      config.send "qiniu_#{key}=", val
    end
  end
end

if Rails.env.test? || Rails.env.cucumber?
  CarrierWave.configure do |config|
    config.storage = :file
    config.enable_processing = false
  end
end
