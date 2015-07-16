# == Schema Information
#
# Table name: posts
#
#  id             :integer          not null, primary key
#  content        :text(65535)      not null
#  user_id        :integer          default(0), not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  parent_id      :integer
#  ip             :integer          default(0), not null
#  group_id       :integer
#  topic_id       :integer          default(0), not null
#  floor          :integer
#  neg            :integer          default(0), not null
#  pos            :integer          default(0), not null
#  score          :integer          default(0), not null
#  anonymous      :boolean          default(FALSE), not null
#  status         :string(255)      default(""), not null
#  ancestry       :string(255)      default(""), not null
#  ancestry_depth :integer          default(0), not null
#  parent_floor   :integer
#  mentioned      :string(255)
#
# Indexes
#
#  article_id                                (topic_id,floor) UNIQUE
#  index_posts_on_ancestry                   (ancestry)
#  index_posts_on_reshare_and_parent_id      (parent_id)
#  index_posts_on_topic_id_and_parent_floor  (topic_id,parent_floor)
#  pk                                        (group_id,topic_id,floor) UNIQUE
#

class PostSerializer < ActiveModel::Serializer
  attributes :id, :content, :status, :pos, :neg
end
