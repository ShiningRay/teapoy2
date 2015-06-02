# coding: utf-8
module BadgesHelper
  def show_badge(b)
    image_tag b.icon.small.url, :title => b.title
  end
end
