WeiboOAuth2::Config.api_key = "1898592352"
WeiboOAuth2::Config.api_secret = '1cf8056abde9b4dcb97f7bfa6bae74a5'
if Rails.env.production?
  WeiboOAuth2::Config.redirect_uri = 'http://www.bling0.com/syncs/sina/callback'
else
	WeiboOAuth2::Config.redirect_uri = 'http://test.bling0.com/syncs/sina/callback'
end