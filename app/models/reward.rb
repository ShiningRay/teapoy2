# coding: utf-8
# == Schema Information
#
# Table name: rewards
#
#  id          :integer          not null, primary key
#  rewarder_id :integer          not null
#  post_id     :string(24)
#  winner_id   :integer          not null
#  amount      :integer
#  anonymous   :boolean          default(FALSE)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Reward < ActiveRecord::Base
  include Tenacity
  # attr_accessible :amount, :winner_id, :spender_id
  attr_accessor :no_charge
  belongs_to :rewarder, class_name: 'User'
  belongs_to :winner, class_name: 'User'
  t_belongs_to :post

  validates :amount, :numericality => {:only_integer => true, :greater_than => 0}
  validates_uniqueness_of :rewarder_id, :scope => :post_id
  validates_each :rewarder_id do |model, attr, val|
    Rails.logger.debug "#{model.inspect} #{attr.inspect} #{val.inspect}"
    model.errors.add(attr, 'cannot reward to yourself') if val == model.winner.id
  end

  before_create :charge_credit, :unless => :no_charge
  def charge_credit
    transaction do
      rewarder.spend_credit amount, "reward @#{winner.login} in \##{post_id}"
      winner.gain_credit amount, "rewarded by @#{rewarder.login} in \##{post_id}"
    end
  end
  private :charge_credit
  def self.make(sender, post, amount, anonymous=false)
    create(rewarder_id: sender.id, post_id: post.id.to_s, winner_id: post.user_id, amount: amount, anonymous: anonymous)
  end
  def self.migrate
    id = 0
    Article.unscoped do
      loop do
        recs = connection.select_all("select * from posts where `type` like 'Reward' and id > #{id} order by id asc limit 2000")
        break if recs.size == 0
        recs.each do |rec|
          begin
          id = rec['id']
          puts id
          meta = MessagePack.unpack(rec['meta'])
          a = {}
          article = Article.find_by_id(rec['article_id'])
          post = article.posts.find_by_floor(rec['parent_id'])
          if post
            a[:amount] = meta['amount']
            a[:rewarder_id] = rec['user_id']
            a[:post_id] = post.id
            a[:winner_id] = post[:user_id]
            a[:anonymous] = rec['anonymous']
            a[:created_at] = rec['created_at']
            a[:updated_at] = rec['updated_at']
            r = Reward.new a
            r.no_charge = true
            r.save!
            meta['described_type'] = 'Reward'
            meta['described_id'] = r.id
            connection.execute("update posts set type='Post', meta=#{sanitize meta.to_msgpack} where id=#{id}")
          else
            connection.execute("delete from posts where id=#{id}")
          end
          rescue
            puts rec.id
            puts $!.message
            #puts $!.backtrace.join("\n")
          end
        end
      end
    end
  end
end
