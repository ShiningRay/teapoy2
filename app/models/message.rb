# coding: utf-8
# == Schema Information
#
# Table name: messages
#
#  id           :integer          not null, primary key
#  owner_id     :integer          not null
#  sender_id    :integer          not null
#  recipient_id :integer          not null
#  content      :text(65535)      not null
#  read         :boolean          default(FALSE), not null
#  created_at   :datetime
#  updated_at   :datetime
#  target_id    :integer
#
# Indexes
#
#  index_messages_on_owner_id_and_target_id  (owner_id,target_id)
#  owner_id                                  (owner_id,sender_id,read)
#

class Message < ActiveRecord::Base
  belongs_to :owner, :class_name => "User", :foreign_key => 'owner_id'
  belongs_to :sender, :class_name => "User", :foreign_key => 'sender_id'
  belongs_to :recipient, :class_name => 'User', :foreign_key => 'recipient_id'
  belongs_to :target, class_name: 'User'
  belongs_to :conversation, foreign_key: %i(owner_id target_id), counter_cache: true

  scope :after, -> (start) { where("id > ?", start) }
  scope :before, -> (e) { where("id < ?", e) }
  scope :latest, -> { order('id desc') }

  before_validation do
    if out?
      self.target_id ||= recipient_id
    else
      self.target_id ||= sender_id
    end
  end

  after_save do
    build_conversation unless conversation
    conversation.last_content = content
    conversation.save
  end

  scope :unread, -> { where(:read => false) }

  validates_length_of :content, :minimum => 1, :allow_nil => false, :allow_blank => false

  def in?
    owner_id == recipient_id
  end

  def out?
    owner_id == sender_id
  end

  def partner
    in? ? sender : recipient
  end

  def self.read!
    update_all(read: true)
  end

  def self.send_message(from, to, content)
    from = User.wrap(from)
    to = User.wrap(to)
    # return false if to.disliked?(from)
    message = {
      :sender_id => from.id,
      :recipient_id => to.id,
      :content => content
    }
    message[:owner_id] = from.id
    out_message = Message.new(message)
    out_message.read = true
    message[:owner_id] = to.id
    in_message = Message.new(message)
    in_message.read = false
    out_message.save!
    in_message.save!
    [out_message, in_message]
  end

  def self.send_system_message(to, content)
    to = User.wrap(to)
    message = {
      :sender_id => 1,
      :recipient_id => to.id,
      :content => content,
      :owner_id => to.id,
      :read => false
    }
    Message.create message
  end
end
