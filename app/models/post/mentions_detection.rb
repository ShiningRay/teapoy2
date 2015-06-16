# encoding: utf-8
module Post::MentionsDetection
  extend ActiveSupport::Concern

  included do
    before_create :find_mention
    field :mentioned, type: Array
    #has_and_belongs_to_many :mentioned_users,
  end

  MENTION_REGEXP = /(?:@|\uFF20)([a-zA-Z0-9_-]*)([^\s@\uFF20]*)/

  def find_mention
    #cnt = 0
    mentioned_users = Set.new

    self.content.gsub! MENTION_REGEXP do |match|
      
      u = User.wrap($1) unless $1.blank?
      other = $2

      # 如果按照登录名没被找到，则使用昵称进行查找
      unless u
        u = User.find_by_name("#$1#$2")
        other = ''
      end

      if u and u.is_a?(User) and u.id > 0
        mentioned_users << u
        "@#{u.login}#{other}"
      else
        match
      end
    end unless content.blank?

    mentioned_users.delete(user) # don't send mention to self
    self.mentioned = mentioned_users.collect{|i|i.id}
  end
end
