#!/usr/bin/env ruby
# coding: utf-8

class CommentWorker  < BaseWorker
  def vote(opt)
    @comment = Comment.find opt[:comment_id]
    if @comment.article.group_id == 1 or @comment.article.group_id == 3
      if opt[:score] > 0
        @comment.increment :pos
        @comment.increment :score
      else
        @comment.increment :neg
        @comment.decrement :score
      end
      @comment.save!
    else
      return if @comment.user_id == opt[:user_id]
      if @comment.vote opt[:user_id], opt[:score]
        puts "vote comment #{opt.inspect}"
      else
        puts "vote comment fail #{opt.inspect}"
      end
    end
  rescue => e
    puts e
    puts e.backtrace.join("\n")
  end

  ## FIXME
  def sweep_cache(comment_id)
    comment = Comment.find comment_id
    article_id = comment.article_id
    group =  comment.article.group
    domain = comment.article.group.domain
  rescue => e
    puts e
    #puts e.backtrace.join("\n")
  end

  def update_score(comment_id)
    comment = Comment.find comment_id
    article = comment.article
    return unless article.status == 'publish'
    score = article.ensure_score
    c = article.comments.public.count
    if score.public_comments_count != c
      score.public_comments_count = c
      score.save!
    end
  rescue => e
    puts e
    puts e.backtrace.join("\n")
  end

  # notify comment author when his/her comment is commented by another user
  def notify_comment(comment_id)
    puts "comment parent #{comment_id}"
    comment = Comment.find comment_id


  rescue Exception => e
    puts e
    puts e.backtrace.join("\n")
  end

  # when new comments was left on an article, update those who're watching the
  # article in order that they can saw the comments on their favoriates page
  def notify_watchers(comment_id)
    comment = Comment.find comment_id

    comment.notify_watchers
    puts "notify #{ids.join(',')}"
  end

  def number_floor(article_id)
    comments = Comment.public.where(:floor => nil).order('id asc').lock.each do |c|
      next if c.floor or c.status != 'publish'
      c.number_floor
    end
  rescue => e
    puts e
    puts e.backtrace.join("\n")
  end

  def detect_parent(comment_id)
    comment = Comment.find comment_id
    article = comment.article
    comment.detect_parent
  rescue => e
    puts e
    puts e.backtrace.join("\n")
  end
end
