# coding: utf-8
class ExternalPage < Post
  class Source
    include Mongoid::Document
    field :link
    index({link: 1}, {unique: true})
  end
  %i(source_link source_site source_alias_links).each do |f|
    field f
  end
  field :unique_id
  after_create :fetch

  def fetch
    return unless content.blank?
  end

  def self.url_exists?(url)
    Source.where(link: url).count > 0
  end

  after_create do
    Source.create(link: source_link)
  end

end
