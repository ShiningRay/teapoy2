#!/usr/bin/env ruby
# coding: utf-8

# 将内容同步至SNS网站
class SyncSocialWorker
  include Sidekiq::Worker
  def perform(article_id)
    article = Topic.find article_id
    sina_token = article.user.user_tokens.sina
    return unless sina_token
    return if sina_token.expired?
    client = sina_token.client
    return unless client
    return unless article.top_post
    content = "【#{article.title}】" unless article.title.blank?
    content = "#{content}#{article.top_post.content}"
    content = content[0..119]
    content << " http://www.bling0.com/#{article.group.alias}/#{article.id}"
    if article.top_post.is_a?(ExternalVideo)
      content << " "
      content << article.top_post.video_page_link
    end
    res = (if article.top_post.is_a?(Picture)
      client.statuses.upload(content, open(article.top_post.picture.path))
    else
      client.statuses.update(content)
    end)
    article[:social_sync] ||= {}
    article[:social_sync]['sina'] = res
    article.save
  rescue OAuth2::Error => e
    handle_oauth_error(e, sina_token, article)
  rescue ActiveRecord::RecordNotFound
  end

  # 如果出现错误，则给用户发小纸条
  def handle_oauth_error(err, token, article)
    case err.code
      when 'expired_token'
        token.expires_at = Time.now
        token.save
        content = "由于您的新浪微博登录信息已过期，所以无法同步文章至新浪微博，请重新绑定"
      when 'invalid_access_token'
        token.destroy
        content = "由于您的新浪微博登录信息无效，所以无法同步文章至新浪微博，请重新绑定"
    end
    Message.send_system_message article.user, content
  end
end