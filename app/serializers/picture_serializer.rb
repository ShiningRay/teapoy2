class PictureSerializer < PostSerializer
  attributes :picture
  def picture
    {
      original: add_host_prefix(object.picture.url(:original))
    }
  end
  def add_host_prefix(url)
    ActionController::Base.asset_host.blank? ? url : URI.join(ActionController::Base.asset_host, url)
  end
end
