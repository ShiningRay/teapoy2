class PictureSerializer < PostSerializer
  attributes :picture
  def picture
    {
      original: add_host_prefix(object.picture.original.url)
    }
  end
  def add_host_prefix(url)
    if ActionController::Base.asset_host.present?
      h = ActionController::Base.asset_host.respond_to?(:call) ? ActionController::Base.asset_host.call : ActionController::Base.asset_host.to_s
      File.join(h, url)
    else
      url
    end
  end
end
