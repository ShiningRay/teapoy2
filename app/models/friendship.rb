# coding: utf-8
# == Schema Information
#
# Table name: friendships
#
#  id         :integer          not null, primary key
#  user_id    :integer          not null
#  friend_id  :integer          not null
#  created_at :datetime
#
# Indexes
#
#  index_friendships_on_user_id_and_friend_id  (user_id,friend_id) UNIQUE
#

class Friendship < ActiveRecord::Base
  belongs_to :user
  belongs_to :friend, :class_name => 'User', :foreign_key => 'friend_id'
end
