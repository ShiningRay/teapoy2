WeiboOAuth2::Config.api_key = Rails.application.secrets.oauth['weibo']['key']
WeiboOAuth2::Config.api_secret = Rails.application.secrets.oauth['weibo']['secret']
if Rails.env.production?
  WeiboOAuth2::Config.redirect_uri = 'http://www.bling0.com/syncs/sina/callback'
else
	WeiboOAuth2::Config.redirect_uri = 'http://test.bling0.com/syncs/sina/callback'
end
