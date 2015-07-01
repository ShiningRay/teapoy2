# encoding: utf-8
module Post::ParentDetection
  extend ActiveSupport::Concern
  included do
    attr_accessor :translate_instruct
    before_create :detect_parent, :if => :translate_instruct
  end
  module ClassMethods
    def detect_parent(content)
    end

    def detect_vote(content)

    end
  end
  #module InstanceMethods
    def detect_parent
      return if top?
      if parent_id.blank? or parent_id == 0
        if content =~ /(\d+)\s*(l|L|F|f|楼)/
          self.parent = topic.comments.find_by_floor $1
        end
      end

      content.scan(/(顶|拍)?\s*(\d+)\s*(l|L|F|f|楼)\s*(\+|-)?/).each do |a,floor,c,d|
        s = 1
        if a
          s = -1 if a == '拍'
        elsif d
          s = -1 if d == '-'
        else
          next
        end
        p = topic.comments.find_by_floor(floor) or next
        #vote(:post_id => p.id, :score => s, :user_id => user_id)
        parent.vote(user_id, s)
      end unless content.blank?
    end
  #end
end
