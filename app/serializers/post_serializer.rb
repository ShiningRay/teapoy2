class PostSerializer < ActiveModel::Serializer
  attributes :id, :content, :status, :pos, :neg
end
