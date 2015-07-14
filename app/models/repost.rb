 # coding: utf-8
class Repost
  # include Mongoid::Document
  # # acts_as_top_post_only
  # class Index
  #   include Mongoid::Document
  #   include Tenacity
  #   embedded_in :repost

  #   belongs_to :original_post, class_name: 'Post', foreign_key: :original_id, inverse_of: nil
  #   belongs_to :original_topic, class_name: 'Topic', inverse_of: nil
  #   belongs_to :original_group, class_name: 'Group', inverse_of: nil
  #   t_belongs_to :sharer, class_name: 'User', foreign_key: :sharer_id
  #   belongs_to :topic
  #   belongs_to :group

  #   index({original_id: 1, group_id: 1})

  #   validates :group_id, uniqueness: {scope: :original_id, message: 'You cannot repost a post to a group twice'}
  #   validate :check_repost_type, on: :create

  #   def check_repost_type
  #     errors.add(:post_id, "Cannot repost the repost type") if new_record? and original_post.is_a?(Repost)
  #   end
  # end

  # embeds_one :index, class_name: 'Repost::Index', autobuild: true
  # belongs_to :original_post, class_name: 'Post', foreign_key: :original_id, inverse_of: nil

  # field :path, type: String
  # field :via

  # def original_post
  #   @original_post ||= Post.find_by_id original_id
  # end

  # def sharer
  #   @sharer ||= User.find_by_id sharer_id
  # end

  # def check_repost_exists_in_that_group
  #   errors.add(:group_id, "Repost already exists in that group") if new_record? and original_post.reposted_to?(group)
  # end

  # skip_callback :create, :before, :detect_parent

  # def repost?
  #   true
  # end

  # def sharer=(user)
  #   @sharer = user
  #   self.sharer_id = user.id
  # end

  # def original_topic
  #   original_post.topic
  # end

  # def original_group
  #   original_post.group || original_post.topic.group
  # end

  # def siblings
  #   @siblings ||= index.original_post.reposts.where(:id.ne => id)
  # end

  # def sibling_topics
  #   siblings.collect{|s|s.topic}
  # end

  # delegate :repost_to, :reposted_to?, to: :original_post

  # after_create :_create_index, :unless => :index

  # def _create_index
  #   #logger.debug('testaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa')
  #   create_index!( :sharer_id => sharer_id,
  #                   :original_id => original_id,
  #                   :original_topic_id => original_topic.id,
  #                   :original_group_id => original_group.id,
  #                   :group_id => group_id || topic.group_id,
  #                   :topic_id => topic_id)
  #   #logger.debug(index)
  # end
  # def move_to(group)
  #   group_id = group.id
  #   save!
  #   index.group_id = group.id
  #   index.save!
  # end

  # after_destroy :remove_index
  # def remove_index
  #   Index.where(:repost_id => self).delete_all
  # end

  # def self.create_index
  #   find_each do |repost|
  #     #begin
  #       repost._create_index
  #     #rescue
  #     #  puts '.'
  #     #end
  #   end
  # end

  # private :_create_index, :remove_index

  # def self.migrate_index_to_mongodb
  #   conn = ActiveRecord::Base.connection
  #   id = 0
  #   loop do
  #     records = conn.select "select * from post_reposts where id > #{id} limit 1000"
  #     break if records.size == 0
  #     records.each do |rec|
  #       id = rec['_id'] = rec.delete('id')
  #       Repost.collection.find(_id: rec['repost_id']).update('$set' => {'index' => rec})
  #     end
  #   end
  # end
end
