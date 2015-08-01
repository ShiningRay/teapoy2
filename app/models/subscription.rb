# coding: utf-8
# == Schema Information
#
# Table name: subscriptions
#
#  id               :integer          not null, primary key
#  subscriber_id    :integer
#  publication_id   :integer
#  publication_type :string(32)
#  viewed_at        :datetime
#  created_at       :datetime
#  updated_at       :datetime
#  unread_count     :integer          default(0), not null
#
# Indexes
#
#  index_subscriptions_on_subscriber_id_and_article_id  (subscriber_id,publication_id,publication_type) UNIQUE
#  index_subscriptions_on_updated_at                    (updated_at)
#  index_subscriptions_on_viewed_at                     (viewed_at)
#

class Subscription < ActiveRecord::Base
  belongs_to :subscriber, class_name: 'User'
  belongs_to :publication, polymorphic: true
  self.record_timestamps = false
  scope :has_updates, -> { where("updated_at > viewed_at").order("updated_at desc") }
  scope :by_publication, -> (publication) { where(publication_type: publication.class.name, publication_id: publication.id) }
  scope :by_subscriber, -> (user) { where(subscriber_id: User.wrap(user).id) }
  validates :subscriber_id, :publication_type, :publication_id, presence: true
  # attr_accessible :subscriber, :publication
  def cache_key
    [:sub, subscriber_id, publication_type,  publication_id]
  end

  def publication
    @publication ||= begin
      @publication_class ||= self[:publication_type].constantize
      @publication_class.find self[:publication_id]
    end
  end

  def publication=(p)
    @publication = p
    @publication_class = p.class
    self[:publication_type] = @publication_class.name
    self[:publication_id] = @publication.id
    @publication
  end

  def self.notify(type, rec)
    case type
    when String
      typename = type
      type = type.constantize
    when Class
      typename = type.name
    end
    logger.debug "Warning: Skip subscription notification #{__FILE__} #{__LINE__}"
    # t = connection.quote(Time.now, :updated_at)
    # subscriptions = Subscription.where(publication_type: typename)
    # s = rec && rec.respond_to?(:user_id) ? subscriptions.where('subscriber_id != ?', rec.user_id) : subscriptions
    # s.update_all("`updated_at` = #{t} , `unread_count`=`unread_count`+1")#(:updated_at => Time.now)
    #subscriptions.each do |s|
    #  s.increment! :unread_count
    #end
  end

  after_create :pull_content
  protected
  def pull_content
    PullContentWorker.perform_async(self.id)
  end
end

