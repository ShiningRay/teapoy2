class PictureSerializer < PostSerializer
  attributes :picture
  def picture
    {
      original: object.picture.url
    }
  end
end
